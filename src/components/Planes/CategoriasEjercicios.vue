<template>
    <div class="categorias-ejercicios">
        <v-progress-linear :active="cargando" :indeterminate="cargando" absolute top
            color="deep-purple accent-4"></v-progress-linear>
        <h1>🏋️ Categorías de Ejercicios</h1>
        <br>
        <v-data-table :headers="encabezadoTabla" :items="categorias" sort-by="nombre" class="elevation-1"
            :footer-props="{ itemsPerPageText: 'Por página' }">
            <template v-slot:[`item.icono`]="{ item }">
                <v-icon>{{ item.icono || 'mdi-dumbbell' }}</v-icon>
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
            </template>
        </v-data-table>

        <v-snackbar v-model="mostrarMensaje" :timeout="3000" :color="mensaje.color" top>
            {{ mensaje.texto }}
        </v-snackbar>

        <v-btn fab dark x-large elevation="8" color="primary" fixed right bottom @click="mostrarDialogo = true">
            <v-icon dark>add</v-icon>
        </v-btn>

        <v-dialog v-model="mostrarDialogo" persistent max-width="600px">
            <form-categoria-ejercicio @cerrado="onCerrado" @registrar="onRegistrar" :categoria="categoria"
                :titulo="titulo" />
        </v-dialog>

        <v-dialog v-model="mostrarDialogoEliminar" max-width="500px">
            <dialogo-eliminar :nombre="itemSeleccionado" @cancelar="cerrarDialogoEliminar"
                @eliminar="confirmarEliminar" />
        </v-dialog>
    </div>
</template>

<script>
import FormCategoriaEjercicio from './FormCategoriaEjercicio.vue'
import DialogoEliminar from '../Dialogos/DialogoEliminar.vue'
import HttpService from '../../Servicios/HttpService'

export default {
    name: "CategoriasEjercicios",
    components: {
        FormCategoriaEjercicio,
        DialogoEliminar
    },

    data: () => ({
        cargando: false,
        mostrarDialogo: false,
        mostrarDialogoEliminar: false,
        categoria: {
            nombre: "",
            descripcion: "",
            icono: "mdi-dumbbell"
        },
        categorias: [],
        mensaje: {
            texto: "",
            color: ""
        },
        mostrarMensaje: false,
        encabezadoTabla: [
            { text: "Icono", value: "icono", sortable: false },
            { text: "Nombre", value: "nombre", sortable: true },
            { text: "Descripción", value: "descripcion" },
            { text: 'Opciones', value: 'opciones', sortable: false },
        ],
        titulo: "Agregar",
        itemSeleccionado: ""
    }),

    mounted() {
        this.obtenerCategorias();
    },

    methods: {
        editar(categoria) {
            this.titulo = "Editar";
            this.categoria = { ...categoria };
            this.mostrarDialogo = true;
        },

        eliminar(categoria) {
            this.itemSeleccionado = categoria.nombre;
            this.categoria = { ...categoria };
            this.mostrarDialogoEliminar = true;
        },

        cerrarDialogoEliminar() {
            this.mostrarDialogoEliminar = false;
            this.categoria = {
                nombre: "",
                descripcion: "",
                icono: "mdi-dumbbell"
            };
        },

        confirmarEliminar() {
            this.cargando = true;
            let payload = {
                metodo: "delete",
                id: this.categoria.id
            };

            HttpService.eliminar("categorias_ejercicios.php", payload)
                .then(eliminado => {
                    if (eliminado) {
                        this.mostrarDialogoEliminar = false;
                        this.mostrarMensaje = true;
                        this.mensaje.texto = "Categoría eliminada";
                        this.mensaje.color = "success";
                        this.cargando = false;
                        this.obtenerCategorias();
                    }
                })
                .catch(error => {
                    this.cargando = false;
                    this.mostrarMensaje = true;
                    this.mensaje.texto = "Error al eliminar la categoría";
                    this.mensaje.color = "error";
                    console.error("Error al eliminar:", error);
                });
        },

        onCerrado(valor) {
            this.categoria = {
                nombre: "",
                descripcion: "",
                icono: "mdi-dumbbell"
            };
            this.mostrarDialogo = valor;
            this.titulo = "Agregar";
        },

        onRegistrar(categoria) {
            let metodo = (this.titulo === "Agregar") ? "post" : "put";
            this.categoria = categoria;
            this.cargando = true;

            let payload = {
                metodo: metodo,
                categoria: this.categoria
            };

            HttpService.registrar(payload, "categorias_ejercicios.php")
                .then(respuesta => {
                    if (respuesta) {
                        this.categoria = {
                            nombre: "",
                            descripcion: "",
                            icono: "mdi-dumbbell"
                        };
                        this.mostrarDialogo = false;
                        this.mostrarMensaje = true;
                        this.mensaje.texto = "Categoría registrada";
                        this.mensaje.color = "success";
                        this.cargando = false;
                        this.obtenerCategorias();
                        this.titulo = "Agregar";
                    }
                })
                .catch(error => {
                    this.cargando = false;
                    this.mostrarMensaje = true;
                    this.mensaje.texto = "Error al registrar la categoría";
                    this.mensaje.color = "error";
                    console.error("Error al registrar:", error);
                });
        },

        obtenerCategorias() {
            this.cargando = true;
            let payload = { metodo: "get" };

            HttpService.obtenerConDatos(payload, "categorias_ejercicios.php")
                .then(respuesta => {
                    this.categorias = respuesta;
                    this.cargando = false;
                })
                .catch(error => {
                    this.cargando = false;
                    this.mostrarMensaje = true;
                    this.mensaje.texto = "Error al cargar las categorías";
                    this.mensaje.color = "error";
                    console.error("Error al obtener categorías:", error);
                });
        }
    }
}
</script>

<style scoped>
.categorias-ejercicios {

    padding: 30px;
    background: linear-gradient(145deg, #1e1e1e, #252525);
    border-radius: 16px;
    min-height: 100vh;
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
}
</style>