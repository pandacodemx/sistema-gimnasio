<template>
    <div class="ejercicios">
        <v-progress-linear :active="cargando" :indeterminate="cargando" absolute top
            color="deep-purple accent-4"></v-progress-linear>

        <h1>🏋️ Ejercicios</h1>
        <br>

        <!-- Barra de búsqueda y filtros -->
        <v-card class="mb-6">
            <v-card-title class="primary white--text">
                <v-icon left dark>mdi-weight-lifter</v-icon>
                Biblioteca de Ejercicios
            </v-card-title>
            <v-card-text>
                <v-row class="mt-4">
                    <v-col cols="12" md="6">
                        <v-text-field v-model="search" append-icon="mdi-magnify" label="Buscar ejercicios" single-line
                            hide-details clearable></v-text-field>
                    </v-col>
                    <v-col cols="12" md="6" class="text-right">
                        <v-btn color="primary" @click="mostrarDialogo = true">
                            <v-icon left>mdi-plus</v-icon>
                            Nuevo Ejercicio
                        </v-btn>
                    </v-col>
                </v-row>

                <!-- Filtros por categoría -->
                <v-chip-group v-model="categoriaFiltro" mandatory active-class="primary--text" class="mt-4">
                    <v-chip filter outlined class="category-chip" :value="null">
                        Todas las categorías
                    </v-chip>
                    <v-chip v-for="category in categorias" :key="category.id" filter outlined class="category-chip"
                        :value="category.id">
                        <v-icon left small>{{ category.icono || 'mdi-dumbbell' }}</v-icon>
                        {{ category.nombre }}
                    </v-chip>
                </v-chip-group>

                <!-- Filtros adicionales -->
                <v-row class="mt-2">
                    <v-col cols="12" sm="6" md="3">
                        <v-select v-model="filtros.dificultad" :items="nivelesDificultad" label="Nivel de dificultad"
                            clearable outlined dense></v-select>
                    </v-col>
                    <v-col cols="12" sm="6" md="3">
                        <v-select v-model="filtros.equipamiento" :items="tiposEquipamiento" label="Equipamiento"
                            clearable outlined dense></v-select>
                    </v-col>
                </v-row>
            </v-card-text>
        </v-card>

        <!-- Lista de ejercicios -->
        <v-data-table :headers="encabezados" :items="ejerciciosFiltrados" sort-by="nombre" class="elevation-1"
            :footer-props="{ itemsPerPageText: 'Por página' }">
            <template v-slot:[`item.categoria`]="{ item }">
                {{ obtenerNombreCategoria(item.categoria_id) }}
            </template>
            <template v-slot:[`item.nivel_dificultad`]="{ item }">
                <v-chip :color="obtenerColorDificultad(item.nivel_dificultad)" small dark>
                    {{ item.nivel_dificultad || 'No especificado' }}
                </v-chip>
            </template>
            <template v-slot:[`item.met`]="{ item }">
                {{ item.met || 'N/A' }}
            </template>
            <template v-slot:[`item.opciones`]="{ item }">
                <v-tooltip bottom color="secondary">
                    <template v-slot:activator="{ on, attrs }">
                        <v-btn color="secondary" small fab dark v-bind="attrs" v-on="on" @click="editar(item)">
                            <v-icon>mdi-pencil-box-outline</v-icon>
                        </v-btn>
                    </template>
                    <span>Editar</span>
                </v-tooltip>
                <v-tooltip bottom color="error">
                    <template v-slot:activator="{ on, attrs }">
                        <v-btn color="error" small fab dark v-bind="attrs" v-on="on" @click="eliminar(item)">
                            <v-icon>mdi-delete</v-icon>
                        </v-btn>
                    </template>
                    <span>Eliminar</span>
                </v-tooltip>
                <v-tooltip bottom color="info">
                    <template v-slot:activator="{ on, attrs }">
                        <v-btn color="info" small fab dark v-bind="attrs" v-on="on" @click="verDetalles(item)">
                            <v-icon>mdi-eye</v-icon>
                        </v-btn>
                    </template>
                    <span>Ver detalles</span>
                </v-tooltip>
            </template>
        </v-data-table>

        <v-snackbar v-model="mostrarMensaje" :timeout="3000" :color="mensaje.color" top>
            {{ mensaje.texto }}
        </v-snackbar>

        <v-btn fab dark x-large elevation="8" color="primary" fixed right bottom @click="mostrarDialogo = true">
            <v-icon dark>add</v-icon>
        </v-btn>

        <!-- Diálogo para agregar/editar ejercicio -->
        <v-dialog v-model="mostrarDialogo" persistent max-width="800px">
            <form-ejercicio @cerrado="onCerrado" @registrar="onRegistrar" :ejercicio="ejercicioEditar"
                :titulo="tituloDialogo" :categorias="categorias" />
        </v-dialog>

        <!-- Diálogo de confirmación para eliminar -->
        <v-dialog v-model="mostrarDialogoEliminar" max-width="500px">
            <dialogo-eliminar :nombre="itemSeleccionado" @cancelar="cerrarDialogoEliminar"
                @eliminar="confirmarEliminar" />
        </v-dialog>

        <!-- Diálogo para ver detalles -->
        <v-dialog v-model="mostrarDialogoDetalles" max-width="800px">
            <v-card v-if="ejercicioSeleccionado">
                <v-img :src="ejercicioSeleccionado.imagen_url || 'https://via.placeholder.com/800x400?text=Ejercicio'"
                    height="200px"></v-img>

                <v-card-title class="headline">
                    {{ ejercicioSeleccionado.nombre }}
                    <v-chip v-if="ejercicioSeleccionado.nivel_dificultad" class="ml-2"
                        :color="obtenerColorDificultad(ejercicioSeleccionado.nivel_dificultad)" small dark>
                        {{ ejercicioSeleccionado.nivel_dificultad }}
                    </v-chip>
                </v-card-title>

                <v-card-text>
                    <v-row>
                        <v-col cols="12" md="6">
                            <h3 class="subtitle-1">Descripción</h3>
                            <p>{{ ejercicioSeleccionado.descripcion || 'Sin descripción' }}</p>

                            <h3 class="subtitle-1 mt-4">Instrucciones</h3>
                            <p>{{ ejercicioSeleccionado.instrucciones || 'Sin instrucciones' }}</p>
                        </v-col>

                        <v-col cols="12" md="6">
                            <h3 class="subtitle-1">Detalles</h3>
                            <v-simple-table>
                                <tbody>
                                    <tr>
                                        <td><strong>Categoría:</strong></td>
                                        <td>{{ obtenerNombreCategoria(ejercicioSeleccionado.categoria_id) }}</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Nivel de dificultad:</strong></td>
                                        <td>{{ ejercicioSeleccionado.nivel_dificultad || 'No especificado' }}</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Equipamiento:</strong></td>
                                        <td>{{ ejercicioSeleccionado.equipamiento || 'No especificado' }}</td>
                                    </tr>
                                    <tr>
                                        <td><strong>MET:</strong></td>
                                        <td>{{ ejercicioSeleccionado.met || 'N/A' }}</td>
                                    </tr>
                                </tbody>
                            </v-simple-table>

                            <div v-if="ejercicioSeleccionado.video_url" class="mt-4">
                                <h3 class="subtitle-1">Video demostrativo</h3>
                                <v-btn color="primary" :href="ejercicioSeleccionado.video_url" target="_blank">
                                    Ver video
                                    <v-icon right>mdi-open-in-new</v-icon>
                                </v-btn>
                            </div>
                        </v-col>
                    </v-row>
                </v-card-text>

                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" text @click="mostrarDialogoDetalles = false">Cerrar</v-btn>
                    <v-btn color="primary" text @click="editar(ejercicioSeleccionado)">Editar</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </div>
</template>

<script>
import FormEjercicio from './FormEjercicio.vue'
import DialogoEliminar from '../Dialogos/DialogoEliminar.vue'
import HttpService from '../../Servicios/HttpService'

export default {
    name: "Ejercicios",
    components: {
        FormEjercicio,
        DialogoEliminar
    },

    data: () => ({
        cargando: false,
        mostrarDialogo: false,
        mostrarDialogoEliminar: false,
        mostrarDialogoDetalles: false,
        ejercicioEditar: {
            id: null,
            nombre: "",
            descripcion: "",
            instrucciones: "",
            categoria_id: null,
            imagen_url: "",
            video_url: "",
            met: null,
            nivel_dificultad: null,
            equipamiento: null
        },
        ejercicioSeleccionado: null,
        ejercicios: [],
        categorias: [],
        mensaje: {
            texto: "",
            color: ""
        },
        mostrarMensaje: false,
        encabezados: [
            { text: "Nombre", value: "nombre", sortable: true },
            { text: "Categoría", value: "categoria", sortable: true },
            { text: "Dificultad", value: "nivel_dificultad", sortable: true },
            { text: "MET", value: "met", sortable: true },
            { text: "Equipamiento", value: "equipamiento", sortable: true },
            { text: 'Opciones', value: 'opciones', sortable: false, width: '180px' },
        ],
        tituloDialogo: "Agregar",
        itemSeleccionado: "",
        search: "",
        categoriaFiltro: null,
        filtros: {
            dificultad: null,
            equipamiento: null
        },
        nivelesDificultad: ['principiante', 'intermedio', 'avanzado'],
        tiposEquipamiento: ['peso corporal', 'mancuernas', 'barra', 'kettlebell', 'bandas elásticas', 'máquina', 'balón medicinal', 'steps']
    }),

    computed: {
        ejerciciosFiltrados() {
            let filtered = this.ejercicios;

            // Filtrar por categoría
            if (this.categoriaFiltro !== null) {
                filtered = filtered.filter(ejercicio => ejercicio.categoria_id === this.categoriaFiltro);
            }

            // Filtrar por texto de búsqueda
            if (this.search) {
                const searchLower = this.search.toLowerCase();
                filtered = filtered.filter(ejercicio =>
                    ejercicio.nombre.toLowerCase().includes(searchLower) ||
                    (ejercicio.descripcion && ejercicio.descripcion.toLowerCase().includes(searchLower))
                );
            }

            // Filtrar por dificultad
            if (this.filtros.dificultad) {
                filtered = filtered.filter(ejercicio =>
                    ejercicio.nivel_dificultad === this.filtros.dificultad
                );
            }

            // Filtrar por equipamiento
            if (this.filtros.equipamiento) {
                filtered = filtered.filter(ejercicio =>
                    ejercicio.equipamiento === this.filtros.equipamiento
                );
            }

            return filtered;
        }
    },

    mounted() {
        this.obtenerEjercicios();
        this.obtenerCategorias();
    },

    methods: {
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

        obtenerCategorias() {
            let payload = { metodo: "get" };

            HttpService.obtenerConDatos(payload, "categorias_ejercicios.php")
                .then(respuesta => {
                    this.categorias = respuesta;
                })
                .catch(error => {
                    console.error("Error al obtener categorías:", error);
                });
        },

        editar(ejercicio) {
            this.tituloDialogo = "Editar";
            this.ejercicioEditar = { ...ejercicio };
            this.mostrarDialogo = true;
        },

        eliminar(ejercicio) {
            this.itemSeleccionado = ejercicio.nombre;
            this.ejercicioEditar = { ...ejercicio };
            this.mostrarDialogoEliminar = true;
        },

        verDetalles(ejercicio) {
            this.ejercicioSeleccionado = { ...ejercicio };
            this.mostrarDialogoDetalles = true;
        },

        cerrarDialogoEliminar() {
            this.mostrarDialogoEliminar = false;
            this.ejercicioEditar = {
                id: null,
                nombre: "",
                descripcion: "",
                instrucciones: "",
                categoria_id: null,
                imagen_url: "",
                video_url: "",
                met: null,
                nivel_dificultad: null,
                equipamiento: null
            };
        },

        confirmarEliminar() {
            this.cargando = true;
            let payload = {
                metodo: "delete",
                id: this.ejercicioEditar.id
            };

            HttpService.eliminar("ejercicios.php", payload)
                .then(eliminado => {
                    if (eliminado) {
                        this.mostrarDialogoEliminar = false;
                        this.mostrarMensaje = true;
                        this.mensaje.texto = "Ejercicio eliminado";
                        this.mensaje.color = "success";
                        this.cargando = false;
                        this.obtenerEjercicios();
                    }
                })
                .catch(error => {
                    this.cargando = false;
                    this.mostrarMensaje = true;
                    this.mensaje.texto = "Error al eliminar el ejercicio";
                    this.mensaje.color = "error";
                    console.error("Error al eliminar:", error);
                });
        },

        onCerrado(valor) {
            this.ejercicioEditar = {
                id: null,
                nombre: "",
                descripcion: "",
                instrucciones: "",
                categoria_id: null,
                imagen_url: "",
                video_url: "",
                met: null,
                nivel_dificultad: null,
                equipamiento: null
            };
            this.mostrarDialogo = valor;
            this.tituloDialogo = "Agregar";
        },

        onRegistrar(ejercicio) {
            let metodo = (this.tituloDialogo === "Agregar") ? "post" : "put";
            this.ejercicioEditar = ejercicio;
            this.cargando = true;

            let payload = {
                metodo: metodo,
                ejercicio: this.ejercicioEditar
            };

            HttpService.registrar(payload, "ejercicios.php")
                .then(respuesta => {
                    if (respuesta) {
                        this.ejercicioEditar = {
                            id: null,
                            nombre: "",
                            descripcion: "",
                            instrucciones: "",
                            categoria_id: null,
                            imagen_url: "",
                            video_url: "",
                            met: null,
                            nivel_dificultad: null,
                            equipamiento: null
                        };
                        this.mostrarDialogo = false;
                        this.mostrarMensaje = true;
                        this.mensaje.texto = "Ejercicio registrado";
                        this.mensaje.color = "success";
                        this.cargando = false;
                        this.obtenerEjercicios();
                        this.tituloDialogo = "Agregar";
                    }
                })
                .catch(error => {
                    this.cargando = false;
                    this.mostrarMensaje = true;
                    this.mensaje.texto = "Error al registrar el ejercicio";
                    this.mensaje.color = "error";
                    console.error("Error al registrar:", error);
                });
        },

        obtenerNombreCategoria(categoriaId) {
            const categoria = this.categorias.find(c => c.id === categoriaId);
            return categoria ? categoria.nombre : 'Sin categoría';
        },

        obtenerColorDificultad(nivel) {
            switch (nivel) {
                case 'principiante': return 'green';
                case 'intermedio': return 'orange';
                case 'avanzado': return 'red';
                default: return 'grey';
            }
        }
    }
}
</script>

<style scoped>
.ejercicios {
    padding: 30px;
    background: linear-gradient(145deg, #1e1e1e, #252525);
    border-radius: 16px;
    min-height: 100dvh;
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
}
</style>