<template>
    <div class="lista-rutinas">
        <v-progress-linear :active="cargando" :indeterminate="cargando" absolute top
            color="deep-purple accent-4"></v-progress-linear>

        <v-row class="mb-4" align="center">
            <v-col cols="6">
                <h1>📋 Rutinas de Entrenamiento</h1>
            </v-col>
            <v-col cols="6" class="text-right">
                <v-btn color="primary" @click="$router.push('/rutinas/crear')">
                    <v-icon left>mdi-plus</v-icon>
                    Crear Nueva Rutina
                </v-btn>
            </v-col>
        </v-row>

        <v-card>
            <v-card-title>
                <v-text-field v-model="search" append-icon="mdi-magnify" label="Buscar rutinas" single-line hide-details
                    clearable></v-text-field>
            </v-card-title>

            <v-data-table :headers="headers" :items="rutinas" :search="search" :loading="cargando"
                loading-text="Cargando rutinas..." sort-by="nombre" class="elevation-1">
                <template v-slot:[`item.nivel_dificultad`]="{ item }">
                    <v-chip :color="getColorDificultad(item.nivel_dificultad)" small dark>
                        {{ item.nivel_dificultad }}
                    </v-chip>
                </template>

                <template v-slot:[`item.total_dias`]="{ item }">
                    {{ item.total_dias }} días
                </template>

                <template v-slot:[`item.acciones`]="{ item }">
                    <v-tooltip bottom>
                        <template v-slot:activator="{ on, attrs }">
                            <v-btn icon @click="verRutina(item)" v-bind="attrs" v-on="on">
                                <v-icon color="info">mdi-eye</v-icon>
                            </v-btn>
                        </template>
                        <span>Ver detalles</span>
                    </v-tooltip>

                    <v-tooltip bottom>
                        <template v-slot:activator="{ on, attrs }">
                            <v-btn icon @click="editarRutina(item)" v-bind="attrs" v-on="on">
                                <v-icon color="warning">mdi-pencil</v-icon>
                            </v-btn>
                        </template>
                        <span>Editar rutina</span>
                    </v-tooltip>

                    <v-tooltip bottom>
                        <template v-slot:activator="{ on, attrs }">
                            <v-btn icon @click="asignarRutina(item)" v-bind="attrs" v-on="on">
                                <v-icon color="success">mdi-account-plus</v-icon>
                            </v-btn>
                        </template>
                        <span>Asignar a miembro</span>
                    </v-tooltip>

                    <v-tooltip bottom>
                        <template v-slot:activator="{ on, attrs }">
                            <v-btn icon @click="eliminarRutina(item)" v-bind="attrs" v-on="on">
                                <v-icon color="error">mdi-delete</v-icon>
                            </v-btn>
                        </template>
                        <span>Eliminar rutina</span>
                    </v-tooltip>
                </template>

                <template v-slot:no-data>
                    <v-alert type="info" class="ma-4">
                        No hay rutinas creadas.
                        <v-btn color="primary" text @click="$router.push('/rutinas/crear')">
                            Crear primera rutina
                        </v-btn>
                    </v-alert>
                </template>
            </v-data-table>
        </v-card>

        <!-- Diálogo de detalles -->
        <v-dialog v-model="dialogoDetalles" max-width="800px">
            <v-card v-if="rutinaSeleccionada">
                <v-card-title class="headline">
                    {{ rutinaSeleccionada.nombre }}
                    <v-chip :color="getColorDificultad(rutinaSeleccionada.nivel_dificultad)" class="ml-2" small dark>
                        {{ rutinaSeleccionada.nivel_dificultad }}
                    </v-chip>
                </v-card-title>

                <v-card-text>
                    <v-simple-table>
                        <tbody>
                            <tr>
                                <td><strong>Objetivo:</strong></td>
                                <td>{{ rutinaSeleccionada.objetivo }}</td>
                            </tr>
                            <tr>
                                <td><strong>Duración:</strong></td>
                                <td>{{ rutinaSeleccionada.duracion_semanas }} semanas</td>
                            </tr>
                            <tr>
                                <td><strong>Días por semana:</strong></td>
                                <td>{{ rutinaSeleccionada.total_dias }}</td>
                            </tr>
                            <tr>
                                <td><strong>Descripción:</strong></td>
                                <td>{{ rutinaSeleccionada.descripcion || 'Sin descripción' }}</td>
                            </tr>
                        </tbody>
                    </v-simple-table>

                    <h3 class="subtitle-1 mt-4">Días de entrenamiento:</h3>
                    <v-expansion-panels>
                        <v-expansion-panel v-for="dia in rutinaSeleccionada.dias" :key="dia.id">
                            <v-expansion-panel-header>
                                {{ dia.nombre_dia }}
                            </v-expansion-panel-header>
                            <v-expansion-panel-content>
                                <v-simple-table v-if="dia.ejercicios && dia.ejercicios.length > 0">
                                    <thead>
                                        <tr>
                                            <th>Ejercicio</th>
                                            <th>Series</th>
                                            <th>Repeticiones</th>
                                            <th>Descanso</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="ejercicio in dia.ejercicios" :key="ejercicio.id">
                                            <td>{{ ejercicio.ejercicio_nombre }}</td>
                                            <td>{{ ejercicio.series }}</td>
                                            <td>{{ ejercicio.repeticiones }}</td>
                                            <td>{{ ejercicio.descanso_segundos }}s</td>
                                        </tr>
                                    </tbody>
                                </v-simple-table>
                                <v-alert v-else type="info">No hay ejercicios para este día</v-alert>
                            </v-expansion-panel-content>
                        </v-expansion-panel>
                    </v-expansion-panels>
                </v-card-text>

                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="primary" text @click="dialogoDetalles = false">Cerrar</v-btn>
                    <v-btn color="warning" text @click="editarRutina(rutinaSeleccionada)">Editar</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <!-- Diálogo de eliminación -->
        <v-dialog v-model="dialogoEliminar" max-width="500px">
            <v-card>
                <v-card-title class="headline">¿Eliminar rutina?</v-card-title>
                <v-card-text>
                    ¿Estás seguro de que quieres eliminar la rutina "{{ rutinaAEliminar.nombre }}"?
                    Esta acción no se puede deshacer.
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" text @click="dialogoEliminar = false">Cancelar</v-btn>
                    <v-btn color="error" text @click="confirmarEliminar" :loading="eliminando">Eliminar</v-btn>
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

export default {
    name: "ListaRutinas",
    data: () => ({
        cargando: false,
        eliminando: false,
        search: '',
        rutinas: [],
        rutinaSeleccionada: null,
        rutinaAEliminar: {},
        dialogoDetalles: false,
        dialogoEliminar: false,
        mostrarMensaje: false,
        mensaje: { texto: '', color: '' },
        headers: [
            { text: 'Nombre', value: 'nombre' },
            { text: 'Objetivo', value: 'objetivo' },
            { text: 'Nivel', value: 'nivel_dificultad' },
            { text: 'Duración(Semanas)', value: 'duracion_semanas' },
            { text: 'Días/Semana', value: 'total_dias' },
            { text: 'Acciones', value: 'acciones', sortable: false, align: 'center' }
        ]
    }),

    mounted() {
        this.obtenerRutinas()
    },

    methods: {
        obtenerRutinas() {
            this.cargando = true
            let payload = { metodo: "get" }

            HttpService.obtenerConDatos(payload, "rutinas.php")
                .then(respuesta => {
                    this.rutinas = respuesta
                    this.cargando = false
                })
                .catch(error => {
                    this.cargando = false
                    this.mostrarMensaje = true
                    this.mensaje.texto = "Error al cargar las rutinas"
                    this.mensaje.color = "error"
                    console.error("Error:", error)
                })
        },

        verRutina(rutina) {
            this.cargando = true
            let payload = { metodo: "get_by_id", id: rutina.id }

            HttpService.obtenerConDatos(payload, "rutinas.php")
                .then(respuesta => {
                    this.rutinaSeleccionada = respuesta
                    this.dialogoDetalles = true
                    this.cargando = false
                })
                .catch(error => {
                    this.cargando = false
                    this.mostrarMensaje = true
                    this.mensaje.texto = "Error al cargar los detalles"
                    this.mensaje.color = "error"
                    console.error("Error:", error)
                })
        },

        editarRutina(rutina) {
            this.$router.push(`/rutinas/editar/${rutina.id}`)
        },

        asignarRutina(rutina) {
            this.$router.push(`/rutinas/asignar/${rutina.id}`)
        },

        eliminarRutina(rutina) {
            this.rutinaAEliminar = rutina
            this.dialogoEliminar = true
        },

        confirmarEliminar() {
            this.eliminando = true
            let payload = { metodo: "delete", id: this.rutinaAEliminar.id }

            HttpService.eliminar("rutinas.php", payload)
                .then(eliminado => {
                    if (eliminado) {
                        this.dialogoEliminar = false
                        this.mostrarMensaje = true
                        this.mensaje.texto = "Rutina eliminada correctamente"
                        this.mensaje.color = "success"
                        this.obtenerRutinas()
                    }
                    this.eliminando = false
                })
                .catch(error => {
                    this.eliminando = false
                    this.mostrarMensaje = true
                    this.mensaje.texto = "Error al eliminar la rutina"
                    this.mensaje.color = "error"
                    console.error("Error:", error)
                })
        },

        getColorDificultad(nivel) {
            switch (nivel) {
                case 'principiante': return 'green'
                case 'intermedio': return 'orange'
                case 'avanzado': return 'red'
                default: return 'grey'
            }
        }
    }
}
</script>

<style scoped>
.lista-rutinas {
    padding: 20px;
}
</style>