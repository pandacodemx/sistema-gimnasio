<template>
  <div class="miembros">
    <v-progress-linear :active="cargando" :indeterminate="cargando" absolute top
      color="white accent-4"></v-progress-linear>
    <h1>Productos</h1>
    <v-dialog v-model="dialogoImagen" max-width="800px">
      <v-card>
        <v-img :src="imagenSeleccionada" aspect-ratio="1"></v-img>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="primary" text @click="dialogoImagen = false">Cerrar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-text-field v-model="busqueda" label="Buscar producto..." prepend-inner-icon="mdi-magnify" class="mb-4"
      color="primary" clearable hide-details solo></v-text-field>
    <v-data-table :headers="encabezadoTabla" :items="productos" :search="busqueda" sort-by="nombre" show-expand
      class="elevation-1" :footer-props="{ itemsPerPageText: 'Por página' }">

      <template v-slot:[`item.imagen`]="{ item }">
        <v-avatar size="80" class="cursor-pointer" @click="verImagen(item.imagen)">
          <img :src="urlImagen(item.imagen)" alt="Foto" />
        </v-avatar>
      </template>

      <template v-slot:item.acciones="{ item }">
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

      <template v-slot:expanded-item="{ headers, item }">
        <td :colspan="headers.length" class="pa-6">
          Más información de <b>{{ item.nombre }}</b>
          <v-simple-table height="200px">
            <template v-slot:default>
              <tbody>
                <tr>
                  <td class="pa-6">
                    <v-icon color=" red"> mdi mdi-details </v-icon>
                    <b>Desripcion: </b>{{ item.descripcion }}
                  </td>
                </tr>
              </tbody>
            </template>
          </v-simple-table>
        </td>
      </template>

    </v-data-table>

    <v-snackbar v-model="mostrarMensaje" :timeout="3000" :color="mensaje.color" top>
      {{ mensaje.texto }}
    </v-snackbar>
    <v-btn fab dark x-large elevation="8" color="primary" fixed right bottom @click="mostrarDialogo = true">
      <v-icon dark>add</v-icon>
    </v-btn>

    <v-dialog v-model="mostrarDialogo" persistent max-width="600px">
      <form-producto @cerrado="onCerrado" @registrar="onRegistrar" :producto="producto" :titulo="titulo" />
    </v-dialog>
    <v-dialog v-model="mostrarDialogoEliminar" max-width="500px">
      <dialogo-eliminar :nombre="itemSeleccionado" @cancelar="cerrarDialogoEliminar" @eliminar="confirmarEliminar" />
    </v-dialog>
  </div>
</template>



/////////////////////SCRIPTS////////////
<script>
import FormProducto from './FormProducto.vue';
import DialogoEliminar from '../Dialogos/DialogoEliminar.vue'
import HttpService from '../../Servicios/HttpService'
import Utiles from "../../Servicios/Utiles";
export default {

  name: "Productos",
  components: { FormProducto, DialogoEliminar },
  data: () => ({
    dialogoImagen: false,
    imagenSeleccionada: "",
    busqueda: "",
    cargando: false,
    matriculaSeleccionada: "",
    mostrarDialogo: false,
    mostrarDialogoEliminar: false,
    producto: {
      nombre: "",
      descripcion: "",
      precio: "",
      stock: "",
      categoria: "",
      imagen: "",
    },
    productos: [],
    mensaje: {
      texto: "",
      color: ""
    },
    mostrarMensaje: false,
    encabezadoTabla: [
      {
        text: "Imagen",
        align: "start",
        sortable: false,
        value: "imagen",
      },
      { text: "Nombre", value: "nombre" },
      { text: "Precio", value: "precio" },
      { text: "Categoria", value: "categoria" },
      { text: "Inventario", value: "stock" },
      { text: "Acciones", value: "acciones", sortable: false },
    ],
    titulo: "Agregar",
    itemSeleccionado: ""
  }),

  mounted() {
    this.obtenerProductos();
  },
  methods: {
    verImagen(imagen) {
      this.imagenSeleccionada = this.urlImagen(imagen)
      this.dialogoImagen = true
    },
    urlImagen(imagen) {
      return Utiles.generarURL(imagen);
    },
    editar(producto) {
      this.titulo = "Editar"
      this.producto = { ...producto, imagenActual: producto.imagen }
      this.mostrarDialogo = true
    },
    eliminar(producto) {
      this.itemSeleccionado = producto.nombre
      this.producto = producto
      this.mostrarDialogoEliminar = true
    },
    cerrarDialogoEliminar() {
      this.mostrarDialogoEliminar = false
      this.producto = {
        nombre: "",
        descripcion: "",
        precio: "",
        stock: "",
        categoria: "",
        imagen: "",
      }
    },

    confirmarEliminar() {
      this.cargando = true
      let payload = {
        metodo: "delete",
        id: this.producto.id
      }
      HttpService.eliminar("productos.php", payload)
        .then(eliminado => {
          if (eliminado) {
            this.mostrarDialogoEliminar = false
            this.mostrarMensaje = true
            this.mensaje.texto = "Producto eliminado"
            this.mensaje.color = "success"
            this.cargando = false
            this.obtenerProductos()
          }
        })
    },

    onCerrado(valor) {
      this.producto = {
        nombre: "",
        descripcion: "",
        precio: "",
        stock: "",
        categoria: "",
        imagen: "",
      }
      this.mostrarDialogo = valor
      this.titulo = "Agregar"
    },
    onRegistrar(producto) {
      let metodo = (this.titulo === "Agregar") ? "post" : "put"
      this.producto = producto
      this.cargando = true
      let payload = {
        metodo: metodo,
        producto: this.producto
      }
      HttpService.registrar(payload, "productos.php")
        .then(respuesta => {
          if (respuesta) {
            this.producto = {
              nombre: "",
              descripcion: "",
              precio: "",
              stock: "",
              categoria: "",
              imagen: "",
            }
            this.mostrarDialogo = false
            this.mostrarMensaje = true
            this.mensaje.texto = "Producto registrado correctamente"
            this.mensaje.color = "success"
            this.cargando = false
            this.obtenerProductos()
            this.titulo = "Agregar"
          }

        })

    },
    obtenerProductos() {
      this.cargando = true
      let payload = { metodo: "get" }
      HttpService.obtenerConDatos(payload, "productos.php")
        .then(respuesta => {
          this.productos = respuesta
          this.cargando = false
        })
    }

  }
};
</script>
<style>
.miembros {
  padding: 30px;
  background-color: #1e1e1e;
  border-radius: 12px;
  min-height: 100vh;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
}

.v-data-table {
  background-color: #1e1e1e !important;
  color: #e0e0e0 !important;
}

.v-data-table-header th {
  background-color: #232323 !important;
  color: #ffcc80 !important;
}

.v-data-table__expanded__content {
  background-color: #2a2a2a !important;
}

.v-simple-table td {
  padding: 10px;
  color: #e0e0e0;
  border-bottom: 1px solid #333;
}

.v-icon {
  vertical-align: middle;
}

.v-chip {
  font-weight: bold;
}

.v-tooltip {
  font-size: 13px;
}
</style>
