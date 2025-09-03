<template>
    <div class="creador-rutinas">
        <v-progress-linear :active="cargando" :indeterminate="cargando" absolute top
            color="deep-purple accent-4"></v-progress-linear>

        <h1>📋 Creador de Rutinas</h1>
        <br>

        <v-stepper v-model="pasoActual">
            <!-- Header del Stepper -->
            <v-stepper-header>
                <v-stepper-step step="1" :complete="pasoActual > 1">Información Básica</v-stepper-step>
                <v-divider></v-divider>
                <v-stepper-step step="2" :complete="pasoActual > 2">Configurar Días</v-stepper-step>
                <v-divider></v-divider>
                <v-stepper-step step="3" :complete="pasoActual > 3">Agregar Ejercicios</v-stepper-step>
                <v-divider></v-divider>
                <v-stepper-step step="4">Revisar y Guardar</v-stepper-step>
            </v-stepper-header>

            <!-- Contenido del Stepper -->
            <v-stepper-items>
                <!-- Paso 1: Información Básica -->
                <v-stepper-content step="1">
                    <v-card class="mb-12">
                        <v-card-title>Información Básica de la Rutina</v-card-title>
                        <v-card-text>
                            <v-form ref="formPaso1">
                                <v-row>
                                    <v-col cols="12" md="6">
                                        <v-text-field v-model="rutina.nombre" label="Nombre de la Rutina*"
                                            :rules="[v => !!v || 'El nombre es obligatorio']" required></v-text-field>
                                    </v-col>
                                    <v-col cols="12" md="6">
                                        <v-select v-model="rutina.objetivo" :items="objetivos" label="Objetivo*"
                                            :rules="[v => !!v || 'El objetivo es obligatorio']" required></v-select>
                                    </v-col>
                                    <v-col cols="12" md="6">
                                        <v-select v-model="rutina.nivel_dificultad" :items="nivelesDificultad"
                                            label="Nivel de Dificultad*"
                                            :rules="[v => !!v || 'El nivel es obligatorio']" required></v-select>
                                    </v-col>
                                    <v-col cols="12" md="6">
                                        <v-text-field v-model="rutina.duracion_semanas" label="Duración (semanas)*"
                                            type="number" min="1" :rules="[v => !!v || 'La duración es obligatoria']"
                                            required></v-text-field>
                                    </v-col>
                                    <v-col cols="12">
                                        <v-textarea v-model="rutina.descripcion" label="Descripción"
                                            rows="3"></v-textarea>
                                    </v-col>
                                </v-row>
                            </v-form>
                        </v-card-text>
                    </v-card>

                    <v-btn color="primary" @click="siguientePaso(1)">Continuar</v-btn>
                    <v-btn text @click="cancelar">Cancelar</v-btn>
                </v-stepper-content>

                <!-- Paso 2: Configurar Días -->
                <v-stepper-content step="2">
                    <v-card class="mb-12">
                        <v-card-title>Configurar Días de Entrenamiento</v-card-title>
                        <v-card-text>
                            <p>Selecciona los días de la semana para esta rutina:</p>

                            <v-chip-group v-model="diasSeleccionados" multiple column>
                                <v-chip v-for="(dia, index) in diasSemana" :key="index" :value="dia.value" filter
                                    outlined>
                                    {{ dia.text }}
                                </v-chip>
                            </v-chip-group>

                            <v-divider class="my-4"></v-divider>

                            <div v-if="diasSeleccionados.length > 0">
                                <h3 class="subtitle-1 mb-3">Nombres personalizados para los días:</h3>
                                <v-row v-for="(diaValue, index) in diasSeleccionados" :key="index">
                                    <v-col cols="12" sm="6">
                                        <v-text-field v-model="nombresDias[diaValue]"
                                            :label="`Nombre para ${obtenerNombreDia(diaValue)}`"
                                            :placeholder="`Ej: ${obtenerNombrePorDefecto(diaValue)}`"></v-text-field>
                                    </v-col>
                                </v-row>
                            </div>
                            <v-alert v-else type="info" class="mt-3">
                                Selecciona al menos un día de entrenamiento
                            </v-alert>
                        </v-card-text>
                    </v-card>

                    <v-btn color="primary" @click="siguientePaso(2)" :disabled="diasSeleccionados.length === 0">
                        Continuar
                    </v-btn>
                    <v-btn text @click="pasoActual = 1">Atrás</v-btn>
                    <v-btn text @click="cancelar">Cancelar</v-btn>
                </v-stepper-content>

                <!-- Paso 3: Agregar Ejercicios -->
                <v-stepper-content step="3">
                    <v-card class="mb-12">
                        <v-card-title>Agregar Ejercicios por Día</v-card-title>
                        <v-card-text>
                            <v-tabs v-model="tabDiaActual" grow>
                                <v-tab v-for="diaValue in diasSeleccionados" :key="diaValue">
                                    {{ nombresDias[diaValue] || obtenerNombreDia(diaValue) }}
                                </v-tab>
                            </v-tabs>

                            <v-tabs-items v-model="tabDiaActual" class="mt-4">
                                <v-tab-item v-for="diaValue in diasSeleccionados" :key="diaValue">
                                    <v-card flat>
                                        <v-card-title>
                                            Ejercicios para {{ nombresDias[diaValue] || obtenerNombreDia(diaValue) }}
                                        </v-card-title>
                                        <v-card-text>
                                            <v-btn color="primary" @click="mostrarDialogoEjercicios(diaValue)"
                                                class="mb-4">
                                                <v-icon left>mdi-plus</v-icon>
                                                Agregar Ejercicio
                                            </v-btn>

                                            <draggable v-if="ejerciciosPorDia[diaValue]"
                                                v-model="ejerciciosPorDia[diaValue]" handle=".handle"
                                                @end="reordenarEjercicios(diaValue)">
                                                <v-card v-for="(ejercicio, index) in ejerciciosPorDia[diaValue]"
                                                    :key="index" class="mb-3">
                                                    <v-card-text>
                                                        <v-row align="center">
                                                            <v-col cols="1">
                                                                <v-icon class="handle"
                                                                    style="cursor: move">mdi-drag-horizontal</v-icon>
                                                            </v-col>
                                                            <v-col cols="8">
                                                                <strong>{{ ejercicio.nombre }}</strong>
                                                                <div class="caption">{{ ejercicio.categoria_nombre }}
                                                                </div>
                                                            </v-col>
                                                            <v-col cols="3" class="text-right">
                                                                <v-btn icon
                                                                    @click="editarEjercicioDia(diaValue, index)">
                                                                    <v-icon>mdi-pencil</v-icon>
                                                                </v-btn>
                                                                <v-btn icon
                                                                    @click="eliminarEjercicioDia(diaValue, index)">
                                                                    <v-icon color="error">mdi-delete</v-icon>
                                                                </v-btn>
                                                            </v-col>
                                                        </v-row>
                                                        <v-row v-if="ejercicio.configurado" class="mt-2">
                                                            <v-col cols="4">
                                                                <v-text-field v-model="ejercicio.series" label="Series"
                                                                    type="number" min="1" dense></v-text-field>
                                                            </v-col>
                                                            <v-col cols="4">
                                                                <v-text-field v-model="ejercicio.repeticiones"
                                                                    label="Repeticiones" dense></v-text-field>
                                                            </v-col>
                                                            <v-col cols="4">
                                                                <v-text-field v-model="ejercicio.descanso_segundos"
                                                                    label="Descanso (seg)" type="number" min="0"
                                                                    dense></v-text-field>
                                                            </v-col>
                                                            <v-col cols="12">
                                                                <v-text-field v-model="ejercicio.peso_recomendado"
                                                                    label="Peso recomendado" dense></v-text-field>
                                                            </v-col>
                                                            <v-col cols="12">
                                                                <v-textarea v-model="ejercicio.notas" label="Notas"
                                                                    rows="1" auto-grow dense></v-textarea>
                                                            </v-col>
                                                        </v-row>
                                                    </v-card-text>
                                                </v-card>
                                            </draggable>

                                            <v-alert
                                                v-if="!ejerciciosPorDia[diaValue] || ejerciciosPorDia[diaValue].length === 0"
                                                type="info" class="mt-3">
                                                No hay ejercicios agregados para este día
                                            </v-alert>
                                        </v-card-text>
                                    </v-card>
                                </v-tab-item>
                            </v-tabs-items>
                        </v-card-text>
                    </v-card>

                    <v-btn color="primary" @click="siguientePaso(3)">Continuar</v-btn>
                    <v-btn text @click="pasoActual = 2">Atrás</v-btn>
                    <v-btn text @click="cancelar">Cancelar</v-btn>
                </v-stepper-content>

                <!-- Paso 4: Revisar y Guardar -->
                <v-stepper-content step="4">
                    <v-card class="mb-12">
                        <v-card-title>Revisar y Guardar Rutina</v-card-title>
                        <v-card-text>
                            <h3 class="subtitle-1">Información General</h3>
                            <v-simple-table class="mb-4">
                                <tbody>
                                    <tr>
                                        <td><strong>Nombre:</strong></td>
                                        <td>{{ rutina.nombre }}</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Objetivo:</strong></td>
                                        <td>{{ rutina.objetivo }}</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Nivel:</strong></td>
                                        <td>{{ rutina.nivel_dificultad }}</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Duración:</strong></td>
                                        <td>{{ rutina.duracion_semanas }} semanas</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Descripción:</strong></td>
                                        <td>{{ rutina.descripcion || 'Sin descripción' }}</td>
                                    </tr>
                                </tbody>
                            </v-simple-table>

                            <h3 class="subtitle-1">Días de Entrenamiento</h3>
                            <v-expansion-panels>
                                <v-expansion-panel v-for="diaValue in diasSeleccionados" :key="diaValue">
                                    <v-expansion-panel-header>
                                        {{ nombresDias[diaValue] || obtenerNombreDia(diaValue) }}
                                    </v-expansion-panel-header>
                                    <v-expansion-panel-content>
                                        <v-simple-table
                                            v-if="ejerciciosPorDia[diaValue] && ejerciciosPorDia[diaValue].length > 0">
                                            <thead>
                                                <tr>
                                                    <th>Ejercicio</th>
                                                    <th>Series</th>
                                                    <th>Repeticiones</th>
                                                    <th>Descanso</th>
                                                    <th>Peso</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr v-for="(ejercicio, index) in ejerciciosPorDia[diaValue]"
                                                    :key="index">
                                                    <td>{{ ejercicio.nombre }}</td>
                                                    <td>{{ ejercicio.series || '-' }}</td>
                                                    <td>{{ ejercicio.repeticiones || '-' }}</td>
                                                    <td>{{ ejercicio.descanso_segundos ? ejercicio.descanso_segundos +
                                                        's' : '-' }}</td>
                                                    <td>{{ ejercicio.peso_recomendado || '-' }}</td>
                                                </tr>
                                            </tbody>
                                        </v-simple-table>
                                        <v-alert v-else type="info">
                                            No hay ejercicios para este día
                                        </v-alert>
                                    </v-expansion-panel-content>
                                </v-expansion-panel>
                            </v-expansion-panels>
                        </v-card-text>
                    </v-card>

                    <v-btn color="primary" @click="guardarRutina" :loading="guardando">Guardar Rutina</v-btn>
                    <v-btn text @click="pasoActual = 3">Atrás</v-btn>
                    <v-btn text @click="cancelar">Cancelar</v-btn>
                </v-stepper-content>
            </v-stepper-items>
        </v-stepper>

        <!-- Diálogo para seleccionar ejercicios -->
        <v-dialog v-model="dialogoEjercicios" max-width="800px">
            <v-card>
                <v-card-title>Seleccionar Ejercicio</v-card-title>
                <v-card-text>
                    <v-text-field v-model="busquedaEjercicio" append-icon="mdi-magnify" label="Buscar ejercicios"
                        clearable></v-text-field>

                    <v-list>
                        <v-list-item v-for="ejercicio in ejerciciosFiltrados" :key="ejercicio.id"
                            @click="seleccionarEjercicio(ejercicio)">
                            <v-list-item-avatar>
                                <v-img :src="ejercicio.imagen_url || 'https://via.placeholder.com/50?text=Ejercicio'" />
                            </v-list-item-avatar>
                            <v-list-item-content>
                                <v-list-item-title>{{ ejercicio.nombre }}</v-list-item-title>
                                <v-list-item-subtitle>{{ ejercicio.categoria_nombre }}</v-list-item-subtitle>
                            </v-list-item-content>
                            <v-list-item-action>
                                <v-icon>mdi-plus</v-icon>
                            </v-list-item-action>
                        </v-list-item>
                    </v-list>

                    <v-alert v-if="ejerciciosFiltrados.length === 0" type="info">
                        No se encontraron ejercicios
                    </v-alert>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" text @click="dialogoEjercicios = false">Cancelar</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <v-snackbar v-model="mostrarMensaje" :timeout="3000" :color="mensaje.color" top>
            {{ mensaje.texto }}
        </v-snackbar>
    </div>
</template>

<script>
import HttpService from '../../Servicios/HttpService'
import draggable from 'vuedraggable'

export default {
    name: "CreadorRutinas",
    components: {
        draggable
    },
    data: () => ({
        cargando: false,
        guardando: false,
        pasoActual: 1,
        tabDiaActual: null,
        dialogoEjercicios: false,
        diaSeleccionadoParaEjercicios: null,
        busquedaEjercicio: '',

        rutina: {
            nombre: '',
            descripcion: '',
            nivel_dificultad: '',
            duracion_semanas: 4,
            objetivo: '',
            creada_por: 1 // ID del instructor logueado
        },

        diasSeleccionados: [],
        nombresDias: {},
        ejerciciosPorDia: {},
        ejercicios: [],
        objetivos: [
            'Perdida_grasa', 'Ganancia_muscular', 'Fuerza', 'Resistencia', 'General'
        ],
        nivelesDificultad: ['principiante', 'intermedio', 'avanzado'],
        diasSemana: [
            { text: 'Lunes', value: 1 },
            { text: 'Martes', value: 2 },
            { text: 'Miércoles', value: 3 },
            { text: 'Jueves', value: 4 },
            { text: 'Viernes', value: 5 },
            { text: 'Sábado', value: 6 },
            { text: 'Domingo', value: 7 }
        ],

        mensaje: {
            texto: '',
            color: ''
        },
        mostrarMensaje: false
    }),

    computed: {
        ejerciciosFiltrados() {
            if (!this.busquedaEjercicio) return this.ejercicios;

            const searchLower = this.busquedaEjercicio.toLowerCase();
            return this.ejercicios.filter(ejercicio =>
                ejercicio.nombre.toLowerCase().includes(searchLower) ||
                (ejercicio.descripcion && ejercicio.descripcion.toLowerCase().includes(searchLower)) ||
                (ejercicio.categoria_nombre && ejercicio.categoria_nombre.toLowerCase().includes(searchLower))
            );
        }
    },

    mounted() {
        this.obtenerEjercicios();
        if (this.$route.params.id) {
            this.cargarRutinaParaEditar(this.$route.params.id)
        }
    },

    methods: {
        cargarRutinaParaEditar(id) {
            this.cargando = true;

            let payload = {
                metodo: "get_by_id",
                id: parseInt(id)
            };

            HttpService.obtenerConDatos(payload, "rutinas.php")
                .then(rutina => {
                    if (rutina && rutina.success !== false) {
                        // Convertir el objeto a formato que entienda el formulario
                        this.rutina = {
                            id: rutina.id,
                            nombre: rutina.nombre,
                            descripcion: rutina.descripcion,
                            nivel_dificultad: rutina.nivel_dificultad,
                            duracion_semanas: rutina.duracion_semanas,
                            objetivo: rutina.objetivo,
                            creada_por: rutina.creada_por
                        };

                        // Procesar días y ejercicios
                        this.diasSeleccionados = rutina.dias.map(dia => dia.dia_semana);
                        this.nombresDias = {};
                        this.ejerciciosPorDia = {};

                        rutina.dias.forEach(dia => {
                            this.nombresDias[dia.dia_semana] = dia.nombre_dia;
                            this.ejerciciosPorDia[dia.dia_semana] = dia.ejercicios.map(ej => ({
                                id: ej.id,
                                nombre: ej.ejercicio_nombre,
                                categoria_nombre: ej.categoria_nombre,
                                ejercicio_id: ej.ejercicio_id,
                                series: ej.series,
                                repeticiones: ej.repeticiones,
                                peso_recomendado: ej.peso_recomendado,
                                descanso_segundos: ej.descanso_segundos,
                                orden: ej.orden,
                                notas: ej.notas,
                                configurado: true
                            }));
                        });

                        this.cargando = false;
                        this.pasoActual = 4;
                    } else {
                        throw new Error(rutina.message || "Rutina no encontrada");
                    }
                })
                .catch(error => {
                    this.cargando = false;
                    this.mostrarMensaje = true;
                    this.mensaje.texto = "Error al cargar la rutina: " + error.message;
                    this.mensaje.color = "error";
                    console.error("Error:", error);
                });
        },
        obtenerEjercicios() {
            this.cargando = true;
            let payload = { metodo: "get" };

            HttpService.obtenerConDatos(payload, "ejercicios.php")
                .then(respuesta => {
                    this.ejercicios = respuesta;
                    this.cargando = false;
                })
                .catch(error => {
                    this.cargando = false;
                    this.mostrarMensaje = true;
                    this.mensaje.texto = "Error al cargar los ejercicios";
                    this.mensaje.color = "error";
                    console.error("Error al obtener ejercicios:", error);
                });
        },

        siguientePaso(paso) {
            if (paso === 1) {
                if (this.$refs.formPaso1.validate()) {
                    this.pasoActual = 2;
                }
            } else if (paso === 2) {
                // Inicializar arrays para ejercicios por día
                this.diasSeleccionados.forEach(dia => {
                    if (!this.ejerciciosPorDia[dia]) {
                        this.$set(this.ejerciciosPorDia, dia, []);
                    }
                    if (!this.nombresDias[dia]) {
                        this.nombresDias[dia] = this.obtenerNombrePorDefecto(dia);
                    }
                });
                this.pasoActual = 3;
            } else if (paso === 3) {
                this.pasoActual = 4;
            }
        },

        obtenerNombreDia(valor) {
            const dia = this.diasSemana.find(d => d.value === valor);
            return dia ? dia.text : `Día ${valor}`;
        },

        obtenerNombrePorDefecto(valor) {
            const nombresPorDefecto = {
                1: 'Día de Piernas',
                2: 'Día de Pecho',
                3: 'Día de Espalda',
                4: 'Día de Hombros',
                5: 'Día de Brazos',
                6: 'Día de Cardio',
                7: 'Día de Descanso Activo'
            };
            return nombresPorDefecto[valor] || `Día ${valor}`;
        },

        mostrarDialogoEjercicios(diaValue) {

            if (!this.ejerciciosPorDia[diaValue]) {
                this.$set(this.ejerciciosPorDia, diaValue, []);
            }
            this.diaSeleccionadoParaEjercicios = diaValue;
            this.dialogoEjercicios = true;
            this.busquedaEjercicio = '';
        },

        seleccionarEjercicio(ejercicio) {
            const ejercicioConfigurado = {
                ...ejercicio,
                ejercicio_id: ejercicio.id,
                series: 3,
                repeticiones: '10-12',
                descanso_segundos: 60,
                peso_recomendado: '',
                notas: '',
                configurado: false,
                orden: this.ejerciciosPorDia[this.diaSeleccionadoParaEjercicios].length
            };

            this.ejerciciosPorDia[this.diaSeleccionadoParaEjercicios].push(ejercicioConfigurado);
            this.dialogoEjercicios = false;
        },

        editarEjercicioDia(diaValue, index) {
            this.ejerciciosPorDia[diaValue][index].configurado =
                !this.ejerciciosPorDia[diaValue][index].configurado;
        },

        eliminarEjercicioDia(diaValue, index) {
            this.ejerciciosPorDia[diaValue].splice(index, 1);
            this.reordenarEjercicios(diaValue);
        },

        reordenarEjercicios(diaValue) {
            this.ejerciciosPorDia[diaValue].forEach((ejercicio, index) => {
                ejercicio.orden = index;
            });
        },

        guardarRutina() {
            this.guardando = true;

            // Preparar la estructura de datos para enviar al backend
            const rutinaCompleta = {
                ...this.rutina,
                dias: this.diasSeleccionados.map(diaValue => ({
                    dia_semana: diaValue,
                    nombre_dia: this.nombresDias[diaValue] || this.obtenerNombreDia(diaValue),
                    ejercicios: this.ejerciciosPorDia[diaValue].map(ej => ({
                        ejercicio_id: ej.ejercicio_id || ej.id,
                        series: ej.series,
                        repeticiones: ej.repeticiones,
                        peso_recomendado: ej.peso_recomendado,
                        descanso_segundos: ej.descanso_segundos,
                        orden: ej.orden,
                        notas: ej.notas
                    }))
                }))
            };

            let payload = {
                metodo: "post",
                rutina: rutinaCompleta
            };

            HttpService.registrar(payload, "rutinas.php")
                .then(respuesta => {
                    this.guardando = false;
                    if (respuesta && respuesta.success) {
                        this.mostrarMensaje = true;
                        this.mensaje.texto = "Rutina creada exitosamente";
                        this.mensaje.color = "success";

                        // Resetear el formulario después de 2 segundos
                        setTimeout(() => {
                            this.resetearFormulario();
                            this.$router.push('/rutinas');
                        }, 2000);
                    }
                })
                .catch(error => {
                    this.guardando = false;
                    this.mostrarMensaje = true;
                    this.mensaje.texto = "Error al guardar la rutina";
                    this.mensaje.color = "error";
                    console.error("Error al guardar rutina:", error);
                });
        },

        resetearFormulario() {
            this.pasoActual = 1;
            this.rutina = {
                nombre: '',
                descripcion: '',
                nivel_dificultad: '',
                duracion_semanas: 4,
                objetivo: '',
                creada_por: 1
            };
            this.diasSeleccionados = [];
            this.nombresDias = {};
            this.ejerciciosPorDia = {};
            if (this.$refs.formPaso1) {
                this.$refs.formPaso1.reset();
            }
        },

        cancelar() {
            this.$router.go(-1);
        }
    }
}
</script>

<style scoped>
.creador-rutinas {
    padding: 20px;
}

.handle {
    cursor: move;
}
</style>