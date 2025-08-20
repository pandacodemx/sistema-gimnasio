<template>
    <v-container>
        <!-- Barra de herramientas -->
        <v-row class="mb-4" align="center">
            <v-col cols="12" md="6">
                <v-alert type="info" class="mb-4" color="deep-purple accent-2" border="left" elevation="2"
                    icon="mdi-hammer-wrench">
                    Esta sección sigue en construcción. ¡Pronto habrá más funcionalidades!
                </v-alert>
                <v-btn color="primary" @click="dialogNuevaClase = true">
                    <v-icon left>mdi-plus</v-icon> Nueva Clase
                </v-btn>
                <v-btn color="secondary" @click="dialogNuevoHorario = true" class="ml-2">
                    <v-icon left>mdi-clock</v-icon> Programar Horario
                </v-btn>
                <v-btn color="indigo" dark @click="abrirGestionInstructores" class="ml-2">
                    <v-icon left>mdi-account-tie</v-icon>
                    Instructores
                </v-btn>
                <v-btn color="deep-purple" dark @click="abrirGestionSalas" class="ml-2">
                    <v-icon left>mdi-door-open</v-icon>
                    Salas
                </v-btn>
            </v-col>
            <v-col cols="12" md="6">
                <!-- Selector de vista del calendario -->
                <v-btn-toggle v-model="vistaCalendario" mandatory class="mr-4">
                    <v-btn small value="week">
                        <v-icon small>mdi-calendar-week</v-icon>
                        Semana
                    </v-btn>
                    <v-btn small value="month">
                        <v-icon small>mdi-calendar-month</v-icon>
                        Mes
                    </v-btn>
                </v-btn-toggle>

                <!-- Controles de navegación -->
                <v-btn icon @click="navegarCalendario('prev')" class="mx-1">
                    <v-icon>mdi-chevron-left</v-icon>
                </v-btn>
                <v-btn icon @click="hoy()" class="mx-1">
                    Hoy
                </v-btn>
                <v-btn icon @click="navegarCalendario('next')" class="mx-1">
                    <v-icon>mdi-chevron-right</v-icon>
                </v-btn>

                <!-- Selector de rango de fechas -->
                <v-menu ref="menuFecha" v-model="menuFecha" :close-on-content-click="false" class="ml-4">
                    <template v-slot:activator="{ on, attrs }">
                        <v-btn small v-bind="attrs" v-on="on">
                            <v-icon left>mdi-calendar</v-icon>
                            {{ rangoFechasTexto }}
                        </v-btn>
                    </template>
                    <v-date-picker v-model="rangoFechas" range no-title scrollable
                        @input="menuFecha = false; cargarHorarios()"></v-date-picker>
                </v-menu>
            </v-col>
        </v-row>

        <!-- Calendario de Clases -->
        <div class="calendar-container" :class="{ 'month-view': vistaCalendario === 'month' }">
            <v-calendar ref="calendar" v-model="fechaActual" :events="horarios" :event-color="getEventColor"
                :event-margin-bottom="3" @click:event="mostrarDetalleEvento" @click:date="mostrarDisponibilidadFecha"
                :type="vistaCalendario" :start="rangoFechas[0]" :end="rangoFechas[1]"></v-calendar>
        </div>

        <!-- MODAL GESTIÓN DE SALAS -->
        <v-dialog v-model="dialogGestionSalas" max-width="800px" persistent>
            <v-card>
                <v-card-title class="headline">
                    <v-icon left>mdi-door-open</v-icon>
                    Gestión de Salas
                </v-card-title>

                <v-card-text>
                    <v-tabs v-model="tabSalas" grow>
                        <v-tab>Lista de Salas</v-tab>
                        <v-tab>{{ salaEditando ? 'Editar' : 'Nueva' }} Sala</v-tab>
                    </v-tabs>

                    <v-tabs-items v-model="tabSalas">
                        <!-- Pestaña 1: Lista de Salas -->
                        <v-tab-item>
                            <v-simple-table class="mt-4">
                                <template v-slot:default>
                                    <thead>
                                        <tr>
                                            <th>Nombre</th>
                                            <th>Capacidad</th>
                                            <th>Equipamiento</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="sala in salas" :key="sala.id">
                                            <td>{{ sala.nombre }}</td>
                                            <td>{{ sala.capacidad }} personas</td>
                                            <td>{{ sala.equipamiento || 'N/A' }}</td>
                                            <td>
                                                <v-btn icon small @click="editarSala(sala)">
                                                    <v-icon small>mdi-pencil</v-icon>
                                                </v-btn>
                                                <v-btn icon small @click="confirmarEliminarSala(sala)">
                                                    <v-icon small color="error">mdi-delete</v-icon>
                                                </v-btn>
                                            </td>
                                        </tr>
                                    </tbody>
                                </template>
                            </v-simple-table>
                        </v-tab-item>

                        <!-- Pestaña 2: Formulario -->
                        <v-tab-item>
                            <v-form ref="formSala" class="mt-4">
                                <v-text-field v-model="nuevaSala.nombre" label="Nombre de la sala"
                                    :rules="[v => !!v || 'El nombre es requerido']" required></v-text-field>

                                <v-text-field v-model="nuevaSala.capacidad" label="Capacidad" type="number" min="1"
                                    :rules="[v => !!v || 'La capacidad es requerida']" required></v-text-field>

                                <v-textarea v-model="nuevaSala.equipamiento" label="Equipamiento"
                                    placeholder="Ej: Pesas, máquinas cardiovasculares, espejos..."
                                    rows="2"></v-textarea>
                            </v-form>
                        </v-tab-item>
                    </v-tabs-items>
                </v-card-text>

                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="grey" text @click="cerrarDialogoSalas">
                        Cancelar
                    </v-btn>

                    <v-btn color="primary" text @click="guardarSala" v-if="tabSalas === 1">
                        {{ salaEditando ? 'Actualizar' : 'Guardar' }}
                    </v-btn>

                    <v-btn color="primary" text @click="tabSalas = 1" v-if="tabSalas === 0">
                        <v-icon left>mdi-plus</v-icon>
                        Nueva Sala
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Diálogo de confirmación para eliminar sala -->
        <v-dialog v-model="dialogEliminarSala" max-width="400px">
            <v-card>
                <v-card-title class="headline">Confirmar eliminación</v-card-title>
                <v-card-text>
                    ¿Estás seguro de eliminar la sala
                    <strong v-if="salaSeleccionada">{{ salaSeleccionada.nombre }}</strong>
                    <span v-else>esta sala</span>?
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="grey" text @click="dialogEliminarSala = false">Cancelar</v-btn>
                    <v-btn color="red" text @click="eliminarSala">Eliminar</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- MODAL NUEVO INSTRUCTOR -->
        <v-dialog v-model="dialogGestionInstructores" max-width="800px" persistent>
            <v-card>
                <v-card-title class="headline">
                    <v-icon left>mdi-account-tie</v-icon>
                    Gestión de Instructores
                </v-card-title>

                <v-card-text>
                    <v-tabs v-model="tabInstructores" grow>
                        <v-tab>Lista de Instructores</v-tab>
                        <v-tab>{{ instructorEditando ? 'Editar' : 'Nuevo' }} Instructor</v-tab>
                    </v-tabs>

                    <v-tabs-items v-model="tabInstructores">
                        <!-- Pestaña 1: Lista de Instructores -->
                        <v-tab-item>
                            <v-list two-line class="mt-4">
                                <v-list-item-group>
                                    <v-list-item v-for="instructor in instructores" :key="instructor.id">
                                        <v-list-item-content>
                                            <v-list-item-title class="font-weight-bold">
                                                {{ instructor.nombre }}
                                            </v-list-item-title>
                                            <v-list-item-subtitle>
                                                <v-icon small>mdi-certificate</v-icon>
                                                {{ instructor.especialidad || 'Sin especialidad' }}
                                            </v-list-item-subtitle>
                                            <v-list-item-subtitle>
                                                <v-icon small>mdi-email</v-icon>
                                                {{ instructor.email || 'Sin email' }}
                                            </v-list-item-subtitle>
                                            <v-list-item-subtitle>
                                                <v-icon small>mdi-phone</v-icon>
                                                {{ instructor.telefono || 'Sin teléfono' }}
                                            </v-list-item-subtitle>
                                        </v-list-item-content>

                                        <v-list-item-action>
                                            <v-btn icon @click="editarInstructor(instructor)">
                                                <v-icon color="blue">mdi-pencil</v-icon>
                                            </v-btn>
                                            <v-btn icon @click="confirmarEliminarInstructor(instructor)">
                                                <v-icon color="red">mdi-delete</v-icon>
                                            </v-btn>
                                        </v-list-item-action>
                                    </v-list-item>
                                </v-list-item-group>
                            </v-list>
                        </v-tab-item>

                        <!-- Pestaña 2: Formulario -->
                        <v-tab-item>
                            <v-form ref="formInstructor" class="mt-4">
                                <v-text-field v-model="nuevoInstructor.nombre" label="Nombre completo"
                                    :rules="[v => !!v || 'El nombre es requerido']" required></v-text-field>

                                <v-text-field v-model="nuevoInstructor.especialidad" label="Especialidad"
                                    placeholder="Ej: Yoga, Crossfit, Spinning"></v-text-field>

                                <v-text-field v-model="nuevoInstructor.email" label="Email" type="email"
                                    :rules="[v => !v || /.+@.+\..+/.test(v) || 'Email debe ser válido']"></v-text-field>

                                <v-text-field v-model="nuevoInstructor.telefono" label="Teléfono"
                                    type="tel"></v-text-field>
                            </v-form>
                        </v-tab-item>
                    </v-tabs-items>
                </v-card-text>

                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="grey" text @click="cerrarDialogoInstructores">
                        Cancelar
                    </v-btn>

                    <v-btn color="primary" text @click="guardarInstructor" v-if="tabInstructores === 1">
                        {{ instructorEditando ? 'Actualizar' : 'Guardar' }}
                    </v-btn>

                    <v-btn color="primary" text @click="tabInstructores = 1" v-if="tabInstructores === 0">
                        <v-icon left>mdi-plus</v-icon>
                        Nuevo Instructor
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <v-dialog v-model="dialogEliminarInstructor" max-width="400px">
            <v-card>
                <v-card-title class="headline">Confirmar eliminación</v-card-title>
                <v-card-text>
                    ¿Estás seguro de eliminar al instructor
                    <strong v-if="instructorSeleccionado">{{ instructorSeleccionado.nombre }}</strong>
                    <span v-else>este instructor</span>?
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="grey" text @click="dialogEliminarInstructor = false">Cancelar</v-btn>
                    <v-btn color="red" text @click="eliminarInstructor">Eliminar</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>


        <!-- MODAL NUEVA CLASE -->
        <v-dialog v-model="dialogNuevaClase" max-width="600px">
            <v-card>
                <v-card-title>Crear Nueva Clase</v-card-title>
                <v-card-text>
                    <v-form ref="formClase">
                        <v-text-field v-model="nuevaClase.nombre" label="Nombre" required></v-text-field>

                        <v-textarea v-model="nuevaClase.descripcion" label="Descripción"></v-textarea>

                        <v-row>
                            <v-col cols="12" md="6">
                                <v-select v-model="nuevaClase.nivel_dificultad" :items="nivelesDificultad"
                                    label="Nivel de Dificultad"></v-select>
                            </v-col>
                            <v-col cols="12" md="6">
                                <v-text-field v-model="nuevaClase.duracion_min" label="Duración (minutos)" type="number"
                                    min="15" max="180" required></v-text-field>
                            </v-col>
                        </v-row>

                        <v-color-picker v-model="nuevaClase.color_calendario" mode="hexa"></v-color-picker>
                    </v-form>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" text @click="dialogNuevaClase = false">
                        Cancelar
                    </v-btn>
                    <v-btn color="blue darken-1" text @click="guardarClase">
                        Guardar
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- MODAL NUEVO HORARIO -->
        <v-dialog v-model="dialogNuevoHorario" max-width="800px">
            <v-card>
                <v-card-title>Programar Nueva Clase</v-card-title>
                <v-card-text>
                    <v-form ref="formHorario">
                        <v-row>
                            <v-col cols="12" md="4">
                                <v-select v-model="nuevoHorario.id_clase" :items="clases" item-text="nombre"
                                    item-value="id" label="Clase" required></v-select>
                            </v-col>
                            <v-col cols="12" md="4">
                                <v-select v-model="nuevoHorario.id_instructor" :items="instructores" item-text="nombre"
                                    item-value="id" label="Instructor" required></v-select>
                            </v-col>
                            <v-col cols="12" md="4">
                                <v-select v-model="nuevoHorario.id_sala" :items="salas" item-text="nombre"
                                    item-value="id" label="Sala" required></v-select>
                            </v-col>
                        </v-row>

                        <v-row>
                            <v-col cols="12" md="6">
                                <v-menu ref="menuFechaHorario" v-model="menuFechaHorario"
                                    :close-on-content-click="false" transition="scale-transition" offset-y
                                    min-width="auto">
                                    <template v-slot:activator="{ on, attrs }">
                                        <v-text-field v-model="nuevoHorario.fecha" label="Fecha de la clase"
                                            prepend-icon="mdi-calendar" readonly v-bind="attrs"
                                            v-on="on"></v-text-field>
                                    </template>
                                    <v-date-picker v-model="nuevoHorario.fecha" no-title
                                        :min="new Date().toISOString().substr(0, 10)"></v-date-picker>
                                </v-menu>
                            </v-col>

                            <v-col cols="12" md="6">
                                <v-menu ref="menuHoraInicio" v-model="menuHoraInicio" :close-on-content-click="false"
                                    transition="scale-transition" offset-y max-width="290px" min-width="290px">
                                    <template v-slot:activator="{ on, attrs }">
                                        <v-text-field v-model="nuevoHorario.hora_inicio" label="Hora de inicio"
                                            prepend-icon="mdi-clock-time-four-outline" readonly v-bind="attrs"
                                            v-on="on"></v-text-field>
                                    </template>
                                    <v-time-picker v-model="nuevoHorario.hora_inicio" format="24hr"
                                        full-width></v-time-picker>
                                </v-menu>
                            </v-col>
                        </v-row>
                        <v-row>
                            <v-col cols="12" md="6">
                                <v-text-field v-model="nuevoHorario.max_participantes" label="Cupos máximos"
                                    type="number" min="1" max="50"></v-text-field>
                            </v-col>
                        </v-row>

                        <v-row>
                            <v-col cols="12">
                                <v-select v-model="nuevoHorario.repeticion" :items="opcionesRepeticion"
                                    label="Repetición"></v-select>
                            </v-col>
                        </v-row>
                        <v-row v-if="nuevoHorario.repeticion !== 'ninguna'">
                            <v-col cols="12">
                                <v-text-field v-model="nuevoHorario.veces" label="Número de repeticiones" type="number"
                                    min="1" max="52" hint="¿Cuántas veces se repetirá?" persistent-hint></v-text-field>
                            </v-col>
                        </v-row>
                    </v-form>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="grey" text @click="dialogNuevoHorario = false">Cancelar</v-btn>
                    <v-btn color="primary" text @click="guardarHorario">Programar</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Diálogo Detalle Clase -->

        <v-dialog v-model="dialogDetalleClase" max-width="600px">
            <v-card>
                <v-card-title class="headline"
                    :style="{ color: eventoSeleccionado.color, 'border-bottom': `3px solid ${eventoSeleccionado.color}` }">
                    {{ eventoSeleccionado.name }}
                </v-card-title>

                <v-card-text class="pt-4">
                    <v-row dense>
                        <v-col cols="12" md="6">
                            <v-list-item>
                                <v-list-item-icon>
                                    <v-icon color="blue">mdi-account-tie</v-icon>
                                </v-list-item-icon>
                                <v-list-item-content>
                                    <v-list-item-title>Instructor</v-list-item-title>
                                    <v-list-item-subtitle class="font-weight-bold">{{ eventoSeleccionado.instructor
                                    }}</v-list-item-subtitle>
                                </v-list-item-content>
                            </v-list-item>
                        </v-col>

                        <v-col cols="12" md="6">
                            <v-list-item>
                                <v-list-item-icon>
                                    <v-icon color="green">mdi-map-marker</v-icon>
                                </v-list-item-icon>
                                <v-list-item-content>
                                    <v-list-item-title>Sala</v-list-item-title>
                                    <v-list-item-subtitle class="font-weight-bold">{{ eventoSeleccionado.sala
                                    }}</v-list-item-subtitle>
                                </v-list-item-content>
                            </v-list-item>
                        </v-col>
                    </v-row>

                    <v-row dense>
                        <v-col cols="12" md="6">
                            <v-list-item>
                                <v-list-item-icon>
                                    <v-icon color="orange">mdi-clock</v-icon>
                                </v-list-item-icon>
                                <v-list-item-content>
                                    <v-list-item-title>Horario</v-list-item-title>
                                    <v-list-item-subtitle class="font-weight-bold">
                                        {{ formatoHora(eventoSeleccionado.start) }} - {{
                                            formatoHora(eventoSeleccionado.end) }}
                                    </v-list-item-subtitle>
                                </v-list-item-content>
                            </v-list-item>
                        </v-col>

                        <v-col cols="12" md="6">
                            <v-list-item>
                                <v-list-item-icon>
                                    <v-icon color="purple">mdi-timer</v-icon>
                                </v-list-item-icon>
                                <v-list-item-content>
                                    <v-list-item-title>Duración</v-list-item-title>
                                    <v-list-item-subtitle class="font-weight-bold">{{ eventoSeleccionado.duracion }}
                                        minutos</v-list-item-subtitle>
                                </v-list-item-content>
                            </v-list-item>
                        </v-col>
                    </v-row>

                    <v-row dense>
                        <v-col cols="12" md="6">
                            <v-list-item>
                                <v-list-item-icon>
                                    <v-icon color="red">mdi-account-group</v-icon>
                                </v-list-item-icon>
                                <v-list-item-content>
                                    <v-list-item-title>Cupos</v-list-item-title>
                                    <v-list-item-subtitle class="font-weight-bold">
                                        {{ eventoSeleccionado.cuposDisponibles }} / {{ eventoSeleccionado.cuposTotales
                                        }}
                                        disponibles
                                    </v-list-item-subtitle>
                                </v-list-item-content>
                            </v-list-item>
                        </v-col>

                        <v-col cols="12" md="6">
                            <v-list-item>
                                <v-list-item-icon>
                                    <v-icon color="teal">mdi-chart-donut</v-icon>
                                </v-list-item-icon>
                                <v-list-item-content>
                                    <v-list-item-title>Nivel</v-list-item-title>
                                    <v-list-item-subtitle class="font-weight-bold text-capitalize">
                                        {{ eventoSeleccionado.nivel }}
                                    </v-list-item-subtitle>
                                </v-list-item-content>
                            </v-list-item>
                        </v-col>
                    </v-row>
                </v-card-text>

                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="primary" @click="reservarClase" :disabled="eventoSeleccionado.cuposDisponibles <= 0">
                        <v-icon left>mdi-bookmark</v-icon>
                        Reservar Cupo
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
        vistaCalendario: 'week',
        rangoFechas: [new Date().toISOString().substr(0, 10), new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString().substr(0, 10)],
        menuFecha: false,
        dialogNuevaClase: false,
        dialogNuevoHorario: false,
        dialogDetalleClase: false,
        menuHoraInicio: false,
        nuevaClase: {
            nombre: '',
            descripcion: '',
            duracion_min: 60,
            nivel_dificultad: 'intermedio',
            color_calendario: '#1976D2'
        },
        nuevoHorario: {
            id_clase: null,
            id_instructor: null,
            id_sala: null,
            fecha: new Date().toISOString().substr(0, 10),
            hora_inicio: null,
            max_participantes: 20,
            repeticion: 'ninguna',
            veces: 4
        },
        menuFechaHorario: false,
        opcionesRepeticion: [
            { text: 'No repetir', value: 'ninguna' },
            { text: 'Diariamente', value: 'diaria' },
            { text: 'Semanalmente (mismo día)', value: 'semanal' },
            { text: 'Lunes a Viernes', value: 'lunes_viernes' },
            { text: 'Fines de semana', value: 'fin_semana' },
            { text: 'Mensualmente', value: 'mensual' }
        ],
        nivelesDificultad: ['principiante', 'intermedio', 'avanzado'],
        clases: [],
        instructores: [],
        salas: [],
        horarios: [],
        eventoSeleccionado: {},
        timeoutBusqueda: null,
        dialogGestionInstructores: false,
        dialogEliminarInstructor: false,
        tabInstructores: 0,
        nuevoInstructor: {
            nombre: '',
            especialidad: '',
            email: '',
            telefono: ''
        },
        instructorEditando: null,
        instructorSeleccionado: null,
        dialogGestionSalas: false,
        dialogEliminarSala: false,
        tabSalas: 0,
        nuevaSala: {
            nombre: '',
            capacidad: 20,
            equipamiento: ''
        },
        salaEditando: null,
        salaSeleccionado: null
    }),

    computed: {
        rangoFechasTexto() {
            if (this.vistaCalendario === 'month') {
                const start = new Date(this.rangoFechas[0]);
                return start.toLocaleDateString('es-ES', { month: 'long', year: 'numeric' });
            } else {
                const start = new Date(this.rangoFechas[0]);
                const end = new Date(this.rangoFechas[1]);

                // Si es la misma semana, mostrar formato semanal
                const diffTime = Math.abs(end - start);
                const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

                if (diffDays <= 7) {
                    return `Semana del ${start.toLocaleDateString('es-ES', { day: 'numeric', month: 'short' })}`;
                } else {
                    return `${start.toLocaleDateString('es-ES', { day: 'numeric', month: 'short' })} - ${end.toLocaleDateString('es-ES', { day: 'numeric', month: 'short' })}`;
                }
            }
        }
    },
    watch: {
        vistaCalendario(newVal) {
            this.ajustarRangoFechas(newVal);
            this.cargarHorarios();
        }
    },


    mounted() {
        this.cargarDatosIniciales();
        this.cargarHorarios();
    },

    methods: {
        navegarCalendario(direccion) {
            const incremento = this.vistaCalendario === 'month' ? 30 : 7;
            const factor = direccion === 'next' ? 1 : -1;

            const start = new Date(this.rangoFechas[0]);
            const end = new Date(this.rangoFechas[1]);

            start.setDate(start.getDate() + (factor * incremento));
            end.setDate(end.getDate() + (factor * incremento));

            this.rangoFechas = [
                start.toISOString().substr(0, 10),
                end.toISOString().substr(0, 10)
            ];

            this.cargarHorarios();
        },

        hoy() {
            const hoy = new Date().toISOString().substr(0, 10);
            this.ajustarRangoFechas(this.vistaCalendario, hoy);
            this.cargarHorarios();
        },

        ajustarRangoFechas(vista, fechaInicio = this.rangoFechas[0]) {
            const start = new Date(fechaInicio);

            if (vista === 'month') {
                // Primer día del mes
                const firstDay = new Date(start.getFullYear(), start.getMonth(), 1);
                // Último día del mes
                const lastDay = new Date(start.getFullYear(), start.getMonth() + 1, 0);

                this.rangoFechas = [
                    firstDay.toISOString().substr(0, 10),
                    lastDay.toISOString().substr(0, 10)
                ];
            } else {
                // Vista semanal: encontrar lunes de esta semana
                const dayOfWeek = start.getDay();
                const diffToMonday = dayOfWeek === 0 ? -6 : 1 - dayOfWeek;
                const monday = new Date(start);
                monday.setDate(start.getDate() + diffToMonday);

                // Domingo de esta semana
                const sunday = new Date(monday);
                sunday.setDate(monday.getDate() + 6);

                this.rangoFechas = [
                    monday.toISOString().substr(0, 10),
                    sunday.toISOString().substr(0, 10)
                ];
            }
        },
        abrirGestionInstructores() {
            this.dialogGestionInstructores = true;
            this.tabInstructores = 0;
            this.resetFormInstructor();
        },

        cerrarDialogoInstructores() {
            this.dialogGestionInstructores = false;
            this.instructorEditando = null;
            this.resetFormInstructor();
        },
        resetFormInstructor() {
            this.nuevoInstructor = {
                nombre: '',
                especialidad: '',
                email: '',
                telefono: ''
            };
            this.instructorEditando = null;
        },

        editarInstructor(instructor) {
            this.instructorEditando = instructor;
            this.nuevoInstructor = { ...instructor };
            this.tabInstructores = 1;
        },

        confirmarEliminarInstructor(instructor) {
            this.instructorSeleccionado = instructor;
            this.dialogEliminarInstructor = true;
        },

        async guardarInstructor() {
            if (!this.$refs.formInstructor.validate()) {
                this.$store.commit('mostrarMensaje', {
                    texto: 'Por favor complete los campos requeridos',
                    color: 'warning'
                });
                return;
            }

            try {
                const payload = {
                    metodo: this.instructorEditando ? 'actualizar_instructor' : 'crear_instructor',
                    instructor: this.nuevoInstructor
                };

                if (this.instructorEditando) {
                    payload.instructor.id = this.instructorEditando.id;
                }

                await HttpService.registrar(payload, 'clases.php');

                this.$store.commit('mostrarMensaje', {
                    texto: `Instructor ${this.instructorEditando ? 'actualizado' : 'creado'} exitosamente`,
                    color: 'success'
                });

                this.cargarDatosIniciales();
                this.tabInstructores = 0;
                this.resetFormInstructor();

            } catch (error) {
                console.error('Error guardando instructor:', error);
                this.$store.commit('mostrarMensaje', {
                    texto: 'Error al guardar instructor',
                    color: 'error'
                });
            }
        },

        async eliminarInstructor() {
            try {
                const payload = {
                    metodo: 'eliminar_instructor',
                    id: this.instructorSeleccionado.id
                };

                await HttpService.eliminar('clases.php', payload);

                this.$store.commit('mostrarMensaje', {
                    texto: 'Instructor eliminado exitosamente',
                    color: 'success'
                });

                this.dialogEliminarInstructor = false;
                this.cargarDatosIniciales();

            } catch (error) {
                console.error('Error eliminando instructor:', error);
                this.$store.commit('mostrarMensaje', {
                    texto: 'Error al eliminar instructor',
                    color: 'error'
                });
            }
        },
        // MÉTODOS PARA SALAS
        abrirGestionSalas() {
            this.dialogGestionSalas = true;
            this.tabSalas = 0;
            this.resetFormSala();
        },

        cerrarDialogoSalas() {
            this.dialogGestionSalas = false;
            this.salaEditando = null;
            this.resetFormSala();
        },

        resetFormSala() {
            this.nuevaSala = {
                nombre: '',
                capacidad: 20,
                equipamiento: ''
            };
            this.salaEditando = null;
        },

        editarSala(sala) {
            this.salaEditando = sala;
            this.nuevaSala = { ...sala };
            this.tabSalas = 1;
        },

        confirmarEliminarSala(sala) {
            this.salaSeleccionado = sala;
            this.dialogEliminarSala = true;
        },

        async guardarSala() {
            if (!this.$refs.formSala.validate()) {
                this.$store.commit('mostrarMensaje', {
                    texto: 'Por favor complete los campos requeridos',
                    color: 'warning'
                });
                return;
            }

            try {
                const payload = {
                    metodo: this.salaEditando ? 'actualizar_sala' : 'crear_sala',
                    sala: this.nuevaSala
                };

                if (this.salaEditando) {
                    payload.sala.id = this.salaEditando.id;
                }

                await HttpService.registrar(payload, 'clases.php');

                this.$store.commit('mostrarMensaje', {
                    texto: `Sala ${this.salaEditando ? 'actualizada' : 'creada'} exitosamente`,
                    color: 'success'
                });

                this.cargarDatosIniciales();
                this.tabSalas = 0;
                this.resetFormSala();

            } catch (error) {
                console.error('Error guardando sala:', error);
                this.$store.commit('mostrarMensaje', {
                    texto: 'Error al guardar sala',
                    color: 'error'
                });
            }
        },

        async eliminarSala() {
            try {
                const payload = {
                    metodo: 'eliminar_sala',
                    id: this.salaSeleccionado.id
                };

                await HttpService.eliminar('clases.php', payload);

                this.$store.commit('mostrarMensaje', {
                    texto: 'Sala eliminada exitosamente',
                    color: 'success'
                });

                this.dialogEliminarSala = false;
                this.cargarDatosIniciales();

            } catch (error) {
                console.error('Error eliminando sala:', error);
                this.$store.commit('mostrarMensaje', {
                    texto: 'Error al eliminar sala',
                    color: 'error'
                });
            }
        },

        filtrarMiembros() {

            clearTimeout(this.timeoutBusqueda);
            this.timeoutBusqueda = setTimeout(() => {
                this.cargarHorarios();
            }, 300);
        },
        mostrarDisponibilidadFecha(fecha) {
            console.log('Fecha clickeada:', fecha);
            // Aquí puedes implementar la lógica para mostrar disponibilidad
            this.mostrarMensajeLocal(`Disponibilidad para ${fecha.date}`, 'info');
        },
        async cargarDatosIniciales() {
            try {
                const [clasesRes, instructoresRes, salasRes] = await Promise.all([
                    HttpService.obtenerConDatos({ metodo: 'obtener_clases' }, 'clases.php'),
                    HttpService.obtenerConDatos({ metodo: 'obtener_instructores' }, 'clases.php'),
                    HttpService.obtenerConDatos({ metodo: 'obtener_salas' }, 'clases.php')
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
                this.cargando = true;
                const payload = {
                    metodo: 'obtener_horarios',
                    fecha_inicio: this.rangoFechas[0],
                    fecha_fin: this.rangoFechas[1]
                };

                const respuesta = await HttpService.obtenerConDatos(payload, 'clases.php');

                this.horarios = respuesta.map(horario => {

                    const start = this.crearFechaLocal(horario.fecha_hora_inicio);
                    const end = this.crearFechaLocal(horario.fecha_hora_fin);

                    return {
                        id: horario.id,
                        name: horario.nombre_clase,
                        start: start,
                        end: end,
                        color: horario.color_calendario || '#1976D2',
                        timed: true,


                        extendedProps: {
                            instructor: horario.nombre_instructor || 'Sin instructor',
                            sala: horario.nombre_sala || 'Sin sala',
                            cuposDisponibles: horario.cupos_disponibles || 0,
                            cuposTotales: horario.max_participantes || 0,
                            clase: horario.nombre_clase || 'Sin nombre',
                            duracion: horario.duracion_min || 60,
                            nivel: horario.nivel_dificultad || 'intermedio'
                        }
                    };
                });

            } catch (error) {
                console.error('Error cargando horarios:', error);
                this.$store.commit('mostrarMensaje', {
                    texto: 'Error al cargar horarios',
                    color: 'error'
                });
            } finally {
                this.cargando = false;
            }
        },


        crearFechaLocal(fechaString) {
            if (!fechaString) return new Date();


            if (fechaString instanceof Date) return fechaString;


            if (typeof fechaString === 'string') {

                const mysqlRegex = /^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})$/;
                const match = fechaString.match(mysqlRegex);

                if (match) {
                    const [_, year, month, day, hours, minutes, seconds] = match;
                    return new Date(year, month - 1, day, hours, minutes, seconds);
                }
            }


            const fecha = new Date(fechaString);
            return isNaN(fecha.getTime()) ? new Date() : fecha;
        },

        getEventColor(event) {
            return event.color;
        },

        mostrarDetalleEvento({ event }) {

            const extendedProps = event.extendedProps || {};

            this.eventoSeleccionado = {
                id: event.id,
                name: event.name,
                start: event.start,
                end: event.end,
                color: event.color,


                instructor: extendedProps.instructor || 'No especificado',
                sala: extendedProps.sala || 'No especificada',
                cuposDisponibles: extendedProps.cuposDisponibles || 0,
                cuposTotales: extendedProps.cuposTotales || 0,
                clase: extendedProps.clase || 'Sin nombre',
                duracion: extendedProps.duracion || 60,
                nivel: extendedProps.nivel || 'intermedio'
            };

            this.dialogDetalleClase = true;
        },

        formatoHora(fecha) {
            if (!fecha) return 'Hora no disponible';

            // Asegurarse de que es un objeto Date
            const fechaObj = fecha instanceof Date ? fecha : new Date(fecha);

            if (isNaN(fechaObj.getTime())) return 'Hora inválida';

            return fechaObj.toLocaleTimeString('es-MX', {
                hour: '2-digit',
                minute: '2-digit',
                hour12: true
            });
        },

        async guardarClase() {

            if (this.nuevaClase.duracion_min < 15 || this.nuevaClase.duracion_min > 180) {
                this.$store.commit('mostrarMensaje', {
                    texto: 'La duración debe estar entre 15 y 180 minutos',
                    color: 'error'
                });
                return;
            }
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

                if (!this.nuevoHorario.id_clase || !this.nuevoHorario.id_instructor || !this.nuevoHorario.id_sala) {
                    this.$store.commit('mostrarMensaje', {
                        texto: 'Seleccione clase, instructor y sala',
                        color: 'warning'
                    });
                    return;
                }

                if (!this.nuevoHorario.fecha || !this.nuevoHorario.hora_inicio) {
                    this.$store.commit('mostrarMensaje', {
                        texto: 'Seleccione fecha y hora de inicio',
                        color: 'warning'
                    });
                    return;
                }


                const claseSeleccionada = this.clases.find(c => c.id === this.nuevoHorario.id_clase);
                const duracionMinutos = claseSeleccionada ? claseSeleccionada.duracion_min : 60;

                console.log('Fecha seleccionada:', this.nuevoHorario.fecha);
                console.log('Hora seleccionada:', this.nuevoHorario.hora_inicio);
                console.log('Duración minutos:', duracionMinutos);
                const [hours, minutes] = this.nuevoHorario.hora_inicio.split(':');
                const [year, month, day] = this.nuevoHorario.fecha.split('-');

                const fechaHoraInicio = `${year}-${month}-${day} ${hours}:${minutes}:00`;

                const fechaHoraFin = this.sumarMinutosAFechaMySQL(fechaHoraInicio, duracionMinutos);

                console.log('Fecha/hora inicio calculada:', fechaHoraInicio);
                console.log('Fecha/hora fin calculada:', fechaHoraFin);

                if (!this.esFechaValida(fechaHoraInicio) || !this.esFechaValida(fechaHoraFin)) {
                    throw new Error('Las fechas calculadas no son válidas');
                }


                const payload = {
                    metodo: 'programar_horario',
                    horario: {
                        id_clase: this.nuevoHorario.id_clase,
                        id_instructor: this.nuevoHorario.id_instructor,
                        id_sala: this.nuevoHorario.id_sala,
                        fecha_hora_inicio: fechaHoraInicio,
                        fecha_hora_fin: fechaHoraFin,
                        max_participantes: parseInt(this.nuevoHorario.max_participantes) || 20,
                        repeticion: this.nuevoHorario.repeticion || 'ninguna',
                        veces: parseInt(this.nuevoHorario.veces) || 1
                    }
                };

                console.log('Payload enviado:', payload);

                // Enviar al backend
                const resultado = await HttpService.registrar(payload, 'clases.php');

                if (resultado && resultado.error) {
                    throw new Error(resultado.error);
                }

                // Éxito
                let mensajeExito = 'Horario programado exitosamente';
                if (resultado && resultado.creados > 1) {
                    mensajeExito = `${resultado.creados} horarios programados exitosamente`;
                }

                this.$store.commit('mostrarMensaje', {
                    texto: mensajeExito,
                    color: 'success'
                });

                // Limpiar y cerrar
                this.dialogNuevoHorario = false;
                this.resetFormHorario();
                this.cargarHorarios();

            } catch (error) {
                console.error('Error programando horario:', error);
                this.$store.commit('mostrarMensaje', {
                    texto: error.message || 'Error al programar horario',
                    color: 'error'
                });
            }
        },


        sumarMinutosAFechaMySQL(fechaMySQL, minutos) {
            const [fechaPart, horaPart] = fechaMySQL.split(' ');
            const [year, month, day] = fechaPart.split('-');
            const [hours, minutes, seconds] = horaPart.split(':');


            const fecha = new Date(year, month - 1, day, hours, minutes, seconds);
            fecha.setMinutes(fecha.getMinutes() + parseInt(minutos));

            const pad = n => n.toString().padStart(2, '0');
            return `${fecha.getFullYear()}-${pad(fecha.getMonth() + 1)}-${pad(fecha.getDate())} ` +
                `${pad(fecha.getHours())}:${pad(fecha.getMinutes())}:${pad(fecha.getSeconds())}`;
        },

        esFechaValida(fechaMySQL) {
            const regex = /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/;
            if (!regex.test(fechaMySQL)) return false;

            const [fechaPart, horaPart] = fechaMySQL.split(' ');
            const [year, month, day] = fechaPart.split('-').map(Number);
            const [hours, minutes, seconds] = horaPart.split(':').map(Number);


            if (year < 2000 || year > 2100) return false;
            if (month < 1 || month > 12) return false;
            if (day < 1 || day > 31) return false;
            if (hours < 0 || hours > 23) return false;
            if (minutes < 0 || minutes > 59) return false;

            return true;
        },


        crearFechaHoraCorrecta(fechaStr, horaStr) {
            if (!fechaStr || !horaStr) return new Date();


            const [hours, minutes] = horaStr.split(':').map(Number);


            const fecha = new Date(fechaStr);
            fecha.setHours(hours, minutes, 0, 0);

            return fecha;
        },
        resetFormHorario() {
            this.nuevoHorario = {
                id_clase: null,
                id_instructor: null,
                id_sala: null,
                fecha: new Date().toISOString().substr(0, 10),
                hora_inicio: null,
                max_participantes: 20,
                repeticion: 'ninguna',
                veces: 4
            };
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


.v-tab {
    font-weight: 600;
}


.v-list-item__title {
    font-size: 1.1rem;
}

.v-list-item__subtitle {
    font-size: 0.9rem;
}


.v-list-item__action {
    margin-left: 16px;
}

.calendar-container {
    position: relative;
    height: 600px;
    overflow: hidden;
}

.calendar-container.month-view {
    height: 800px;
}

/* Mejora la visualización en móviles */
@media (max-width: 960px) {
    .calendar-container {
        height: 500px;
    }

    .calendar-container.month-view {
        height: 700px;
    }
}

/* Personalización del calendario */
.v-calendar {
    border-radius: 4px;
    box-shadow: 0 3px 5px -1px rgba(0, 0, 0, 0.2),
        0 5px 8px 0 rgba(0, 0, 0, 0.14),
        0 1px 14px 0 rgba(0, 0, 0, 0.12);
}

/* Mejora la visualización de eventos */
.v-event {
    cursor: pointer;
    font-size: 0.85rem;
    padding: 2px 4px;
    border-radius: 2px;
}

/* Botones de navegación */
.v-btn-toggle {
    border-radius: 4px;
    overflow: hidden;
}
</style>