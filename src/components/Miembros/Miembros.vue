<template >
  <div class="miembros">
    <h1>Listado de miembros</h1>
    <v-data-table
      :loading="cargando"
      :headers="encabezadoTabla"
      :items="miembros"
      item-key="matricula"
      show-expand
      class="elevation-1"
      :footer-props="{ itemsPerPageText: 'Por página' }"
    >
      <template v-slot:[`item.imagen`]="{ item }">
        <v-avatar>
          <img :src="urlImagen(item.imagen)" alt="Foto" />
        </v-avatar>
      </template>

      <template v-slot:[`item.estado`]="{ item }">
        <v-chip
          class="ma-2"
          :color="estado(item.estado)"
          text-color="white"
        >
          {{ item.estado }}
          <span v-if="!item.estado">SIN MEMBRESÍA</span>
        </v-chip>
      </template>

      <template v-slot:[`item.opciones`]="{ item }">
        <v-tooltip bottom color="secondary">
          <template v-slot:activator="{ on, attrs }">
            <v-btn
              color="secondary"
              small
              fab
              dark
              v-bind="attrs"
              v-on="on"
              @click="editar(item.id)"
            >
              <v-icon>mdi-pencil-box-outline</v-icon>
            </v-btn>
          </template>
          <span>Editar</span>
        </v-tooltip>       

        <v-tooltip bottom color="blue darken-2">
          <template v-slot:activator="{ on, attrs }">
            <v-btn color="blue darken-2" small fab dark v-bind="attrs" v-on="on" @click="generarCredencial(item)">
              <v-icon> mdi-account-box-outline</v-icon>
            </v-btn>
          </template>
          <span>Generar credencial</span>
        </v-tooltip>

        <v-tooltip bottom color="error">
          <template v-slot:activator="{ on, attrs }">
            <v-btn
              color="error"
              small
              fab
              dark
              v-bind="attrs"
              v-on="on"
              @click="eliminar(item)"
            >
              <v-icon>mdi-delete</v-icon>
            </v-btn>
          </template>
          <span>Eliminar</span>
        </v-tooltip>

        <v-tooltip bottom color="success" v-if="!item.estado || item.estado === 'VENCIDO'">
          <template v-slot:activator="{ on, attrs }">
            <v-btn
              color="success"
              small
              fab
              dark
              v-bind="attrs"
              v-on="on"
              @click="realizarPago(item.matricula)"
            >
              <v-icon>mdi-wallet-membership</v-icon>
            </v-btn>
          </template>
          <span>Realizar pago</span>
        </v-tooltip>
      </template>

      <template v-slot:expanded-item="{ headers, item }">
        <td :colspan="headers.length" class="pa-6">
          Más información de <b>{{ item.nombre }}</b> 
          <v-simple-table height="200px">
            <template v-slot:default>
              <tbody>
                <tr>
                  <td>
                    <v-icon color="red "> mdi-map-marker </v-icon>
                    <b>Dirección: </b>{{ item.direccion }} </td>
                </tr>
                <tr>
                  <td>
                    <v-icon color="red "> mdi-calendar </v-icon>
                    <b>Miembro desde: </b>{{ item.fechaRegistro }} </td>
                </tr>
                <tr>
                  <td>
                    <v-icon color="red "> mdi-calendar-account </v-icon>
                    <b>Edad: </b>{{ item.edad }} </td>
                </tr>
                <tr>
                  <td>
                      <v-icon color="red "> mdi-account </v-icon>
                    <b>En accidente comunicarse con: </b>{{ item.nombreContacto }}, <b>Teléfono:</b> {{ item.telefonoContacto }}</td>
                </tr>
                <tr>
                  <td>
                    <v-icon color="red "> mdi-mother-heart </v-icon>
                    <b>Enfermedades crónicas: </b>{{ item.enfermedad }} </td>
                </tr>
                <tr>
                  <td>
                    <v-icon color="red "> mdi-hospital-building </v-icon>
                    <b>Seguro en : </b>{{ item.institucion }} </td>
                </tr>
              </tbody>
            </template>
          </v-simple-table>
        </td>
      </template>
      <template v-slot:[`item.membresia`]="{ item }">
                    <div
                        class="medalla"
                        :class="claseMembresia(item.membresia)"
                    >
                        <v-icon left small>{{ iconoMembresia(item.membresia) }}</v-icon>
                        {{ item.membresia }}
                    </div>
      </template>
    </v-data-table>
    <v-btn
      fab
      dark
      x-large
      elevation="8"
      color="primary"
      fixed
      right
      bottom
      to="/nuevo-miembro"
    >
      <v-icon dark>add</v-icon>
    </v-btn>
    <v-dialog v-model="mostrarRealizarPago" persistent max-width="600">
      <realizar-pago
        :matricula="matriculaSeleccionada"
        @cerrar="cerrarDialogoPago"
        @pagado="onPagado"
      />
    </v-dialog>

    <v-dialog v-model="mostrarDialogoEliminar" max-width="500px">
      <dialogo-eliminar
        :nombre="itemSeleccionado"
        @cancelar="cerrarDialogoEliminar"
        @eliminar="confirmarEliminar"
      />
    </v-dialog>

  <credencial-miembro :matricula="matriculaSeleccionada" :miembro="miembro"  @impreso="onImpreso" v-if="mostrarCredencial"/> 

    <v-snackbar
      v-model="mostrarMensaje"
      :timeout="3000"
      :color="mensaje.color"
      top
    >
      {{ mensaje.texto }}
    </v-snackbar>

    <v-overlay :value="cargando">
      <v-progress-circular size="64"></v-progress-circular>
    </v-overlay>
  </div>
</template>
<script>
import HttpService from "../../Servicios/HttpService";
import Utiles from "../../Servicios/Utiles";
import RealizarPago from "./RealizarPago.vue";
import DialogoEliminar from "../Dialogos/DialogoEliminar.vue";
import CredencialMiembro from "./CredencialMiembro.vue"

export default {
  name: "Miembros",
  components: { RealizarPago, DialogoEliminar, CredencialMiembro },

  data: () => ({
    encabezadoTabla: [
      {
        text: "Imagen",
        align: "start",
        sortable: false,
        value: "imagen",
      },
      {
        text: "Matrícula",
        sortable: true,
        value: "matricula",
      },
      {
        text: "Nombre",
        sortable: true,
        value: "nombre",
      },
      {
        text: "Teléfono",
        sortable: false,
        value: "telefono",
      },
      {
        text: "Estado",
        sortable: true,
        value: "estado",
      },
      {
        text: "Inicio membresía",
        sortable: true,
        value: "fechaInicio",
      },
      {
        text: "Fin membresía",
        sortable: true,
        value: "fechaFin",
      },
      {
        text: "Membresía",
        sortable: true,
        value: "membresia",
      },
      { text: "Opciones", value: "opciones", sortable: false },
    ],
    cargando: false,
    mostrarMensaje: false,
    mensaje: {
      color: "",
      texto: "",
    },
    miembros: [],
    matriculaSeleccionada: "",
    mostrarRealizarPago: false,
    itemSeleccionado: null,
    miembro: null,
    mostrarDialogoEliminar: false,
    mostrarCredencial: false
  }),

  mounted() {
    this.obtenerMiembros();
  },

  methods: {
    generarCredencial(miembro){
      this.matriculaSeleccionada = miembro.matricula
      this.miembro = miembro
      this.mostrarCredencial = true
    },

    onImpreso(resultado) {
      this.mostrarCredencial = resultado;
    },

    eliminar(miembro) {
      this.itemSeleccionado = miembro.nombre;
      this.miembro = miembro;
      this.mostrarDialogoEliminar = true;
    },

    cerrarDialogoEliminar() {
      this.mostrarDialogoEliminar = false;
      this.miembro = null;
    },

    confirmarEliminar() {
      this.cargando = true;
      let payload = {
        metodo: "eliminar",
        id: this.miembro.id,
      };
      HttpService.eliminar("miembros.php", payload).then((eliminado) => {
        if (eliminado) {
          this.mostrarDialogoEliminar = false;
          this.mostrarMensaje = true;
          this.mensaje.texto = "Miembro eliminado";
          this.mensaje.color = "success";
          this.cargando = false;
          this.obtenerMiembros();
        }
      });
    },

    editar(idMiembro) {
      this.$router.push({
        name: "EditarMiembro",
        params: { id: idMiembro },
      });
    },

    urlImagen(imagen) {
      return Utiles.generarURL(imagen);
    },

    cerrarDialogoPago(resultado) {
      this.mostrarRealizarPago = resultado;
    },

    realizarPago(matricula) {
      this.matriculaSeleccionada = matricula;
      this.mostrarRealizarPago = true;
    },

    onPagado(resultado) {
      if (resultado) {
        this.mostrarRealizarPago = false;
        this.mostrarMensaje = true;
        this.mensaje = {
          color: "success",
          texto: "Pago realizado con éxito",
        };
        this.obtenerMiembros();
      }
    },

    obtenerMiembros() {
      this.cargando = true;
      const payload = { metodo: "get" };
      HttpService.obtenerConDatos(payload, "miembros.php").then((resultado) => {
        this.miembros = resultado;
        this.cargando = false;
      });
    },

    estado(val) {
      return val === "ACTIVO"
        ? "success"
        : val === "VENCIDO"
        ? "error"
        : "warning";
    },
    claseMembresia(nombre) {
        const tipo = nombre.toLowerCase()
        if (tipo.includes('oro')) return 'medalla-oro'
        if (tipo.includes('plata')) return 'medalla-plata'
        if (tipo.includes('bronce')) return 'medalla-bronce'
        if (tipo.includes('premium')) return 'medalla-premium'
        return 'medalla-default'
        },

    iconoMembresia(nombre) {
        const tipo = nombre.toLowerCase()
        if (tipo.includes('oro')) return 'mdi-trophy'
        if (tipo.includes('plata')) return 'mdi-medal'
        if (tipo.includes('bronce')) return 'mdi-star-outline'
        if (tipo.includes('premium')) return 'mdi-diamond'
        return 'mdi-certificate'
    }
  },
};
</script>
<style >
body {
  background-color: #121212;
  color: #e0e0e0;
  font-family: 'Roboto', sans-serif;
}

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