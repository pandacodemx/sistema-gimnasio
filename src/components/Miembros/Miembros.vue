<template>
  <div>
    <div class="miembros">
      <h1>💪🏻 Listado de miembros</h1>

      <v-card class="mb-4">
        <v-card-text>
          <v-row>
            <v-col cols="12" sm="6">
              <v-text-field v-model="busqueda" label="Buscar por nombre" prepend-icon="mdi-magnify" clearable
                @input="filtrarMiembros"></v-text-field>
            </v-col>
          </v-row>
        </v-card-text>
      </v-card>

      <v-data-table :loading="cargando" :headers="encabezadoTabla" :items="miembrosFiltrados" item-key="matricula"
        show-expand class="elevation-1" :footer-props="{ itemsPerPageText: 'Por página' }">
        <template v-slot:[`item.imagen`]="{ item }">
          <v-avatar>
            <img :src="urlImagen(item.imagen)" alt="Foto" />
          </v-avatar>
        </template>

        <template v-slot:[`item.estado`]="{ item }">
          <v-chip class="ma-2" :color="estado(item.estado)" text-color="white">
            {{ item.estado }}
            <span v-if="!item.estado">SIN MEMBRESÍA</span>
          </v-chip>
        </template>

        <template v-slot:[`item.fechaInicio`]="{ item }">
          {{ formatearFechaHora(item.fechaInicio) }}
        </template>

        <template v-slot:[`item.fechaFin`]="{ item }">
          {{ formatearFechaHora(item.fechaFin) }}
        </template>

        <template v-slot:[`item.opciones`]="{ item }">
          <v-tooltip bottom color="green darken-2">
            <template v-slot:activator="{ on, attrs }">
              <v-btn color="green darken-2" small fab dark v-bind="attrs" v-on="on" @click="verEstadoCuenta(item)">
                <v-icon>mdi-file-document</v-icon>
              </v-btn>
            </template>
            <span>Generar estado de cuenta</span>
          </v-tooltip>

          <v-tooltip bottom color="secondary">
            <template v-slot:activator="{ on, attrs }">
              <v-btn color="secondary" small fab dark v-bind="attrs" v-on="on" @click="editar(item.id)">
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
              <v-btn color="error" small fab dark v-bind="attrs" v-on="on" @click="eliminar(item)">
                <v-icon>mdi-delete</v-icon>
              </v-btn>
            </template>
            <span>Eliminar</span>
          </v-tooltip>

          <v-tooltip bottom color="primary" v-if="!item.estado || item.estado === 'VENCIDO'">
            <template v-slot:activator="{ on, attrs }">
              <v-btn color="primary" small fab dark v-bind="attrs" v-on="on" @click="realizarPago(item.matricula)">
                <v-icon>mdi-cash-multiple</v-icon>
              </v-btn>
            </template>
            <span>Adquirir membresia</span>
          </v-tooltip>

          <v-tooltip bottom color="orange" v-if="item.estado && item.estado === 'ACTIVO'">
            <template v-slot:activator="{ on, attrs }">
              <v-btn color="orange" small fab dark v-bind="attrs" v-on="on" @click="confirmarQuitarMembresia(item)">
                <v-icon>mdi-account-cancel</v-icon>
              </v-btn>
            </template>
            <span>Quitar membresía</span>
          </v-tooltip>
        </template>

        <template v-slot:expanded-item="{ headers, item }">
          <td :colspan="headers.length" class="pa-6">
            <div class=" mb-6">
              Información adicional: <b>{{ item.nombre }}</b>
            </div>
            <v-simple-table height="200px">
              <template v-slot:default>
                <tbody>
                  <tr>
                    <td>
                      <v-icon color="red "> mdi-clipboard-account </v-icon>
                      <b>Edad: </b>{{ item.edad }}
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <v-icon color="red "> mdi-map-marker </v-icon>
                      <b>Dirección: </b>{{ item.direccion }}
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <v-icon color="red "> mdi-calendar </v-icon>
                      <b>Miembro desde: </b>{{ formatearFechaHora(item.fechaRegistro) }}
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <v-icon color="red "> mdi-account </v-icon>
                      <b>Contacto de emergencia: </b>{{ item.nombreContacto }}, <b>Teléfono:</b> {{
                        item.telefonoContacto }}
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <v-icon color="red "> mdi-hospital </v-icon>
                      <b>Enfermedades crónicas: </b>{{ item.enfermedad }}
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <v-icon color="red "> mdi-hospital-building </v-icon>
                      <b>Seguridad Social: </b>{{ item.institucion }}
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <v-icon color="red "> mdi-human-child </v-icon>
                      <b>NSS/Numero de afiliación: </b>{{ item.afiliacion }}
                    </td>
                  </tr>
                </tbody>
              </template>
            </v-simple-table>
          </td>
          <tr v-if="historiales[item.matricula]">
            <td colspan="100%">
              <v-simple-table dense>
                <thead>
                  <tr>
                    <th>Fecha</th>
                    <th>Acción</th>
                    <th>Detalle</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(registro, index) in historiales[item.matricula]" :key="index">
                    <td>{{ registro.fecha }}</td>
                    <td>{{ registro.accion }}</td>
                    <td>{{ registro.detalle }}</td>
                  </tr>
                </tbody>
              </v-simple-table>
            </td>
          </tr>
        </template>
        <template v-slot:[`item.membresia`]="{ item }">
          <div class="medalla" :class="claseMembresia(item.membresia)">
            <v-icon left small>{{ iconoMembresia(item.membresia) }}</v-icon>
            {{ item.membresia }}
          </div>
        </template>
      </v-data-table>
      <v-btn fab dark x-large elevation="8" color="primary" fixed right bottom to="/nuevo-miembro">
        <v-icon dark>add</v-icon>
      </v-btn>


      <v-dialog v-model="mostrarRealizarPago" persistent max-width="600">
        <realizar-pago :matricula="matriculaSeleccionada" @cerrar="cerrarDialogoPago" @pagado="onPagado" />
      </v-dialog>

      <v-dialog v-model="mostrarDialogoEliminar" max-width="500px">
        <dialogo-eliminar :nombre="itemSeleccionado" @cancelar="cerrarDialogoEliminar" @eliminar="confirmarEliminar" />
      </v-dialog>



      <credencial-miembro :matricula="matriculaSeleccionada" :miembro="miembro" @impreso="onImpreso"
        v-if="mostrarCredencial" />

      <v-snackbar v-model="mostrarMensaje" :timeout="3000" :color="mensaje.color" top>
        {{ mensaje.texto }}
      </v-snackbar>

      <v-overlay :value="cargando">
        <v-progress-circular size="64"></v-progress-circular>
      </v-overlay>
    </div>


    <v-dialog v-model="modalEstadoCuenta" max-width="800px">
      <v-card>
        <v-card-title class="headline">
          Estado de cuenta - {{ miembroActual.nombre }}
        </v-card-title>

        <v-card-text>
          <v-simple-table>
            <thead>
              <tr>
                <th>Fecha</th>
                <th>Membresía</th>
                <th>Monto</th>
                <th>Cobrado por</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="pago in datosCuenta" :key="pago.fecha">
                <td>{{ formatearFechaHora(pago.fecha) }}</td>
                <td>{{ pago.nombre_membresia }}</td>
                <td>${{ pago.monto }}</td>
                <td>{{ pago.cobrado_por }}</td>
              </tr>
            </tbody>
          </v-simple-table>
        </v-card-text>

        <v-card-actions>
          <v-spacer />
          <v-btn color="primary" @click="modalEstadoCuenta = false">Cerrar</v-btn>
        </v-card-actions>
        <v-btn class="ml-5 mb-5" color="success" @click="descargarEstadoCuenta">Descargar PDF</v-btn>
      </v-card>
    </v-dialog>

    <v-dialog v-model="mostrarDialogoQuitarMembresia" max-width="500px" persistent>
      <v-card>
        <v-card-title class="headline ">
          Quitar membresía
        </v-card-title>

        <v-card-text class="pt-4">
          ¿Estás seguro de quitar la membresía a
          <strong v-if="miembroSeleccionado">{{ miembroSeleccionado.nombre }}</strong>?

        </v-card-text>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="grey" text @click="mostrarDialogoQuitarMembresia = false">
            Cancelar
          </v-btn>
          <v-btn color="orange darken-2" text @click="quitarMembresia">
            Confirmar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>



<script>
import HttpService from "../../Servicios/HttpService";
import Utiles from "../../Servicios/Utiles";
import RealizarPago from "./RealizarPago.vue";
import DialogoEliminar from "../Dialogos/DialogoEliminar.vue";
import CredencialMiembro from "./CredencialMiembro.vue"
import jsPDF from "jspdf";
import autoTable from "jspdf-autotable";

export default {
  name: "Miembros",
  components: { RealizarPago, DialogoEliminar, CredencialMiembro },

  data: () => ({
    busqueda: '',
    miembrosOriginales: [],
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
        formatter: (value) => this.formatearFechaHora(value)
      },
      {
        text: "Fin membresía",
        sortable: true,
        value: "fechaFin",
        formatter: (value) => this.formatearFechaHora(value)
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
    mostrarCredencial: false,
    historiales: {},
    datosCuenta: [],
    miembroActual: {},
    modalEstadoCuenta: false,
    cargando: false,
    mostrarDialogoQuitarMembresia: false,
    miembroSeleccionado: null,
    motivoQuitarMembresia: ''
  }),

  computed: {
    miembrosFiltrados() {
      if (!this.busqueda) return this.miembros;
      const termino = this.busqueda.toLowerCase();
      return this.miembros.filter(miembro =>
        miembro.nombre.toLowerCase().includes(termino)
      );
    }
  },

  mounted() {
    this.obtenerMiembros();
  },

  methods: {
    confirmarQuitarMembresia(miembro) {
      this.miembroSeleccionado = miembro;
      this.motivoQuitarMembresia = '';
      this.mostrarDialogoQuitarMembresia = true;
    },

    async quitarMembresia() {
      this.cargando = true;

      const payload = {
        metodo: "quitar_membresia",
        id: this.miembroSeleccionado.id,
        motivo: this.motivoQuitarMembresia
      };

      try {
        const resultado = await HttpService.eliminar("miembros.php", payload);

        if (resultado) {
          this.mostrarMensaje = true;
          this.mensaje = {
            color: "success",
            texto: "Membresía quitada correctamente"
          };

          // Actualizar el estado localmente
          const index = this.miembros.findIndex(m => m.id === this.miembroSeleccionado.id);
          if (index !== -1) {
            this.$set(this.miembros, index, {
              ...this.miembros[index],
              estado: null,
              fechaInicio: null,
              fechaFin: null,
              membresia: null
            });
          }
        }
      } catch (error) {
        this.mostrarMensaje = true;
        this.mensaje = {
          color: "error",
          texto: "Error al quitar la membresía"
        };
      } finally {
        this.mostrarDialogoQuitarMembresia = false;
        this.cargando = false;
      }
    },

    formatearFechaHora(fechaString) {
      if (!fechaString) return 'Sin fecha';

      const [fechaPart, horaPart] = fechaString.split(' ');
      const [year, month, day] = fechaPart.split('-');
      const [hours, minutes] = horaPart.split(':');
      const meses = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];

      return `${day} ${meses[parseInt(month) - 1]} ${year} ${hours}:${minutes}`;


    },
    descargarEstadoCuenta() {
      const doc = new jsPDF();

      const img = new Image();
      img.src = '/img/logo.png';

      img.onload = () => {

        doc.addImage(img, 'PNG', 150, 10, 40, 20);


        doc.setFontSize(16);
        doc.text(`Estado de cuenta`, 14, 20);
        doc.setFontSize(12);
        doc.text(`Miembro: ${this.miembroActual.nombre}`, 14, 28);
        doc.text(`Matrícula: ${this.miembroActual.matricula}`, 14, 34);


        autoTable(doc, {
          startY: 40,
          head: [["Fecha", "Membresía", "Monto", "Cobrado por"]],
          body: this.datosCuenta.map(p => [
            p.fecha,
            p.nombre_membresia,
            `$${p.monto}`,
            p.cobrado_por
          ]),
          theme: "striped",
          styles: { halign: "left", fontSize: 10 },
          headStyles: { fillColor: [41, 128, 185] },
        });


        doc.save(`Estado_Cuenta_${this.miembroActual.nombre}.pdf`);
      };

      img.onerror = () => {
        console.error("No se pudo cargar el logo.");

        doc.setFontSize(16);
        doc.text(`Estado de cuenta`, 14, 20);
        doc.setFontSize(12);
        doc.text(`Miembro: ${this.miembroActual.nombre}`, 14, 28);
        doc.text(`Matrícula: ${this.miembroActual.matricula}`, 14, 34);

        autoTable(doc, {
          startY: 40,
          head: [["Fecha", "Membresía", "Monto", "Cobrado por"]],
          body: this.datosCuenta.map(p => [
            p.fecha,
            p.nombre_membresia,
            `$${p.monto}`,
            p.cobrado_por
          ]),
          theme: "striped",
          styles: { halign: "left", fontSize: 10 },
          headStyles: { fillColor: [41, 128, 185] },
        });

        doc.save(`Estado_Cuenta_${this.miembroActual.nombre}.pdf`);
      };
    }

    ,
    verEstadoCuenta(miembro) {
      const payload = {
        metodo: "estado_cuenta_miembro",
        matricula: miembro.matricula
      };

      this.cargando = true;
      HttpService.obtenerConDatos(payload, "miembros.php")
        .then(resultado => {
          this.datosCuenta = resultado;
          this.miembroActual = miembro;
          this.modalEstadoCuenta = true;
          this.cargando = false;
        });
    },
    generarCredencial(miembro) {
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
        this.miembrosOriginales = [...resultado];
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
      const tipo = (nombre && nombre.toLowerCase()) || ''
      if (tipo.includes('semanal')) return 'medalla-oro'
      if (tipo.includes('mensual hombre')) return 'medalla-plata'
      if (tipo.includes('mensual mujer')) return 'medalla-mujer'
      if (tipo.includes('mensual pareja / estudiante')) return 'medalla-bronce'
      if (tipo.includes('semestral')) return 'medalla-premium'
      return 'medalla-default'
    },

    iconoMembresia(nombre) {
      const tipo = (nombre && nombre.toLowerCase()) || ''
      if (tipo.includes('semanal')) return 'mdi-trophy'
      if (tipo.includes('mensual hombre')) return 'mdi-face-man'
      if (tipo.includes('mensual mujer')) return 'mdi-face-woman'
      if (tipo.includes('mensual pareja / estudiante')) return 'mdi-human-male-female'
      if (tipo.includes('semestral')) return 'mdi-calendar-range'
      return 'mdi-certificate'
    }
  },
};
</script>



<style>
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


.medalla {
  display: inline-flex;
  align-items: center;
  padding: 6px 12px;
  border-radius: 999px;
  font-weight: bold;
  font-size: 14px;
  color: #fff;
  text-transform: capitalize;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
}

.medalla-oro {
  background: linear-gradient(145deg, #0f4933, #21a572);
  font-size: 12px;
}

.medalla-plata {
  background: linear-gradient(145deg, #016e8f, #03bff8);
  font-size: 12px;
}

.medalla-bronce {
  background: linear-gradient(145deg, #cd3232, #b84333);
  font-size: 12px;
}

.medalla-mujer {
  background: linear-gradient(145deg, #7c1a43, #f35a9a);
  font-size: 12px;
}

.medalla-premium {
  background: linear-gradient(145deg, #6d1a7c, #b83bee);
  font-size: 12px;
}

.medalla-default {
  background: linear-gradient(145deg, #546E7A, #6c8692);
  font-size: 12px;
}
</style>