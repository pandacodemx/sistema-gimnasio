<template>
    <v-container>
        <!-- Barra de herramientas -->
        <v-row class="mb-4">
            <v-col cols="12" md="6">
                <v-btn color="primary" @click="dialogNuevaClase = true">
                    <v-icon left>mdi-plus</v-icon> Nueva Clase
                </v-btn>
                <v-btn color="secondary" @click="dialogNuevoHorario = true" class="ml-2">
                    <v-icon left>mdi-clock</v-icon> Programar Horario
                </v-btn>
            </v-col>
            <v-col cols="12" md="6">
                <v-menu ref="menuFecha" v-model="menuFecha" :close-on-content-click="false">
                    <template v-slot:activator="{ on, attrs }">
                        <v-text-field v-model="rangoFechasTexto" label="Rango de fechas" prepend-icon="mdi-calendar"
                            readonly v-bind="attrs" v-on="on"></v-text-field>
                    </template>
                    <v-date-picker v-model="rangoFechas" range no-title scrollable
                        @input="menuFecha = false; cargarHorarios()"></v-date-picker>
                </v-menu>
            </v-col>
        </v-row>

        <!-- Calendario de Clases -->
        <v-calendar ref="calendar" v-model="fechaActual" :events="horarios" :event-color="getEventColor"
            :event-margin-bottom="3" @click:event="mostrarDetalleEvento" @click:date="mostrarDisponibilidadFecha"
            type="week"></v-calendar>

        <!-- Diálogo Nueva Clase -->
        <v-dialog v-model="dialogNuevaClase" max-width="600px">
            <v-card>
                <v-card-title>Crear Nueva Clase</v-card-title>
                <v-card-text>
                    <v-form ref="formClase">
                        <v-text-field v-model="nuevaClase.nombre" label="Nombre" required></v-text-field>
                        <v-textarea v-model="nuevaClase.descripcion" label="Descripción"></v-textarea>
                        <v-select v-model="nuevaClase.nivel_dificultad" :items="nivelesDificultad"
                            label="Nivel de Dificultad"></v-select>
                        <v-color-picker v-model="nuevaClase.color_calendario" mode="hexa"></v-color-picker>
                    </v-form>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" text @click="dialogNuevaClase = false">Cancelar</v-btn>
                    <v-btn color="blue darken-1" text @click="guardarClase">Guardar</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Diálogo Nuevo Horario -->
        <v-dialog v-model="dialogNuevoHorario" max-width="800px">
            <v-card>
                <v-card-title>Programar Nueva Clase</v-card-title>
                <v-card-text>
                    <v-form ref="formHorario">
                        <v-row>
                            <v-col cols="12" md="6">
                                <v-select v-model="nuevoHorario.id_clase" :items="clases" item-text="nombre"
                                    item-value="id" label="Clase" required></v-select>
                            </v-col>
                            <v-col cols="12" md="6">
                                <v-select v-model="nuevoHorario.id_instructor" :items="instructores" item-text="nombre"
                                    item-value="id" label="Instructor" required></v-select>
                            </v-col>
                        </v-row>
                        <v-row>
                            <v-col cols="12" md="6">
                                <v-menu ref="menuHoraInicio" v-model="menuHoraInicio" :close-on-content-click="false"
                                    :nudge-right="40" transition="scale-transition" offset-y max-width="290px"
                                    min-width="290px">
                                    <template v-slot:activator="{ on, attrs }">
                                        <v-text-field v-model="nuevoHorario.fecha_hora_inicio" label="Hora de inicio"
                                            prepend-icon="mdi-clock-time-four-outline" readonly v-bind="attrs"
                                            v-on="on"></v-text-field>
                                    </template>
                                    <v-time-picker v-model="nuevoHorario.fecha_hora_inicio" format="24hr" full-width
                                        @click:minute="menuHoraInicio = false"></v-time-picker>
                                </v-menu>
                            </v-col>
                            <v-col cols="12" md="6">
                                <v-text-field v-model="nuevoHorario.duracion" label="Duración (minutos)"
                                    type="number"></v-text-field>
                            </v-col>
                        </v-row>
                    </v-form>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" text @click="dialogNuevoHorario = false">Cancelar</v-btn>
                    <v-btn color="blue darken-1" text @click="guardarHorario">Programar</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Diálogo Detalle Clase -->
        <v-dialog v-model="dialogDetalleClase" max-width="500px">
            <v-card>
                <v-card-title class="headline" :style="{ color: eventoSeleccionado.color }">
                    {{ eventoSeleccionado.name }}
                </v-card-title>
                <v-card-text>
                    <p><v-icon left>mdi-account</v-icon> Instructor: {{ eventoSeleccionado.instructor }}</p>
                    <p><v-icon left>mdi-map-marker</v-icon> Sala: {{ eventoSeleccionado.sala }}</p>
                    <p><v-icon left>mdi-clock</v-icon> Horario: {{ formatoHora(eventoSeleccionado.start) }} - {{
                        formatoHora(eventoSeleccionado.end) }}</p>
                    <p><v-icon left>mdi-account-group</v-icon> Cupos disponibles: {{ eventoSeleccionado.cuposDisponibles
                    }}</p>
                </v-card-text>
                <v-card-actions>
                    <v-btn color="primary" @click="reservarClase" :disabled="eventoSeleccionado.cuposDisponibles <= 0">
                        Reservar
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-container>
</template>

<script>
import HttpService from '../../Servicios/HttpService';

export default {
    name: 'GestionClases',
    data: () => ({
        fechaActual: new Date().toISOString().substr(0, 10),
        rangoFechas: [new Date().toISOString().substr(0, 10), new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString().substr(0, 10)],
        menuFecha: false,
        dialogNuevaClase: false,
        dialogNuevoHorario: false,
        dialogDetalleClase: false,
        menuHoraInicio: false,
        nuevaClase: {
            nombre: '',
            descripcion: '',
            nivel_dificultad: 'intermedio',
            color_calendario: '#1976D2'
        },
        nuevoHorario: {
            id_clase: null,
            id_instructor: null,
            id_sala: null,
            fecha_hora_inicio: null,
            duracion: 60,
            repeticion: 'ninguna',
            max_participantes: 20
        },
        nivelesDificultad: ['principiante', 'intermedio', 'avanzado'],
        clases: [],
        instructores: [],
        salas: [],
        horarios: [],
        eventoSeleccionado: {}
    }),

    computed: {
        rangoFechasTexto() {
            return this.rangoFechas.join(' ~ ');
        }
    },

    mounted() {
        this.cargarDatosIniciales();
        this.cargarHorarios();
    },

    methods: {
        async cargarDatosIniciales() {
            try {
                const [clasesRes, instructoresRes, salasRes] = await Promise.all([
                    HttpService.obtener({ metodo: 'obtener_clases' }, 'clases.php'),
                    HttpService.obtener({ metodo: 'obtener_instructores' }, 'clases.php'),
                    HttpService.obtener({ metodo: 'obtener_salas' }, 'clases.php')
                ]);

                this.clases = clasesRes;
                this.instructores = instructoresRes;
                this.salas = salasRes;
            } catch (error) {
                console.error('Error cargando datos iniciales:', error);
            }
        },

        async cargarHorarios() {
            try {
                const payload = {
                    metodo: 'obtener_horarios',
                    fecha_inicio: this.rangoFechas[0],
                    fecha_fin: this.rangoFechas[1]
                };

                const horarios = await HttpService.obtener(payload, 'clases.php');

                // Formatear para el calendario
                this.horarios = horarios.map(horario => ({
                    id: horario.id,
                    name: horario.nombre_clase,
                    start: new Date(horario.fecha_hora_inicio),
                    end: new Date(horario.fecha_hora_fin),
                    color: horario.color_calendario,
                    instructor: horario.nombre_instructor,
                    sala: horario.nombre_sala,
                    cuposDisponibles: horario.max_participantes - horario.reservados || 0
                }));
            } catch (error) {
                console.error('Error cargando horarios:', error);
            }
        },

        getEventColor(event) {
            return event.color;
        },

        mostrarDetalleEvento({ event }) {
            this.eventoSeleccionado = event;
            this.dialogDetalleClase = true;
        },

        formatoHora(fecha) {
            return fecha.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        },

        async guardarClase() {
            try {
                const payload = {
                    metodo: 'crear_clase',
                    clase: this.nuevaClase
                };

                await HttpService.registrar(payload, 'clases.php');
                this.dialogNuevaClase = false;
                this.cargarDatosIniciales();
                this.$store.commit('mostrarMensaje', {
                    texto: 'Clase creada exitosamente',
                    color: 'success'
                });
            } catch (error) {
                console.error('Error creando clase:', error);
            }
        },

        async guardarHorario() {
            try {
                // Formatear fecha completa
                const fechaCompleta = `${this.fechaActual}T${this.nuevoHorario.fecha_hora_inicio}`;
                const fechaFin = new Date(new Date(fechaCompleta).getTime() + this.nuevoHorario.duracion * 60000).toISOString();

                const horarioCompleto = {
                    ...this.nuevoHorario,
                    fecha_hora_inicio: fechaCompleta,
                    fecha_hora_fin: fechaFin
                };

                const payload = {
                    metodo: 'programar_horario',
                    horario: horarioCompleto
                };

                await HttpService.registrar(payload, 'clases.php');
                this.dialogNuevoHorario = false;
                this.cargarHorarios();
                this.$store.commit('mostrarMensaje', {
                    texto: 'Horario programado exitosamente',
                    color: 'success'
                });
            } catch (error) {
                console.error('Error programando horario:', error);
            }
        },

        async reservarClase() {
            try {
                const payload = {
                    metodo: 'registrar_reserva',
                    reserva: {
                        id_miembro: this.$store.getters.userId,
                        id_horario: this.eventoSeleccionado.id
                    }
                };

                await HttpService.registrar(payload, 'clases.php');
                this.dialogDetalleClase = false;
                this.cargarHorarios();
                this.$store.commit('mostrarMensaje', {
                    texto: 'Reserva realizada exitosamente',
                    color: 'success'
                });
            } catch (error) {
                console.error('Error realizando reserva:', error);
            }
        }
    }
};
</script>

<style scoped>
/* Estilos personalizados para el calendario */
.v-calendar-weekly__head-weekday {
    font-weight: bold;
    padding: 8px;
}

.v-event {
    cursor: pointer;
    font-size: 12px;
    padding: 2px 4px;
    border-radius: 2px;
    margin-bottom: 2px;
}

.v-event-title {
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
</style>