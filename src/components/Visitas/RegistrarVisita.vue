<template>
  <div class="miembros">
    <busqueda-miembro @seleccionado="onMiembroSeleccionado" />

    <v-container fluid class="mt-6" v-if="!miembro">
      <v-row justify="center" align="center" no-gutters>
        <v-col cols="12" md="8" lg="6">
          <v-card class="pa-6 elevation-8 card-regular">
            <v-row no-gutters align="center" justify="space-around" class="flex-wrap">
              <v-col cols="12" md="6" class="text-center">
                <v-img
                  src="https://i.ibb.co/67pHfVwZ/3d-sportsman-character-sculpting-upper-body-with-incline-bench-press-workout-free-png.webp"
                  alt="Visita" contain max-width="350" class="mx-auto"></v-img>
              </v-col>
              <v-col cols="12" md="6" class="d-flex flex-column justify-center">
                <h3 class="font-weight-medium mb-4 text-center">
                  Escribe nombre/matrícula del miembro o registra una visita regular para cliente sin membresía.
                </h3>
                <v-btn x-large color="primary" dark rounded class="mx-auto" @click="mostrarDialogoRegular = true">
                  <v-icon left>mdi-check</v-icon>
                  Registrar visita regular
                </v-btn>
              </v-col>
            </v-row>
          </v-card>
        </v-col>
      </v-row>
    </v-container>

    <v-container fluid v-if="miembro" class="mt-10 d-flex justify-center">
      <v-fade-transition>
        <v-card v-if="miembro" class="card-miembro" max-width="400">
          <v-img :src="urlImagen(miembro.imagen)" height="280" class="rounded-top"></v-img>

          <v-card-title class="headline font-weight-bold justify-center">
            {{ miembro.nombre }}
          </v-card-title>

          <v-card-subtitle class="text-center grey--text">
            Matrícula: <strong>{{ miembro.matricula }}</strong>
          </v-card-subtitle>

          <v-divider></v-divider>

          <v-card-text>
            <v-list dense two-line>
              <v-list-item v-if="miembro.membresia">
                <v-list-item-icon>
                  <v-icon color="primary" large>mdi-book-multiple</v-icon>
                </v-list-item-icon>
                <v-list-item-content>
                  <v-list-item-title class="subtitle-1 font-weight-medium">
                    {{ miembro.membresia }}
                  </v-list-item-title>
                  <v-list-item-subtitle>
                    Fin membresía: <strong>{{ miembro.fechaFin }}</strong>
                  </v-list-item-subtitle>
                </v-list-item-content>
              </v-list-item>
            </v-list>

            <v-chip class="ma-2" :color="estado(miembro.estado)" text-color="white" large label>
              {{ miembro.estado || 'SIN MEMBRESÍA' }}
            </v-chip>
          </v-card-text>

          <v-divider></v-divider>

          <v-card-actions class="justify-center py-6">
            <v-btn v-if="miembro.estado === 'ACTIVO'" color="success" dark rounded large @click="abrirRegistrarVisita">
              <v-icon left>mdi-check</v-icon>
              Registrar visita
            </v-btn>

            <v-btn v-if="!miembro.membresia || miembro.estado === 'VENCIDO'" color="warning" dark rounded large
              @click="abrirRealizarPago">
              <v-icon left>mdi-credit-card</v-icon>
              Actualizar membresía
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-fade-transition>
    </v-container>

    <!-- Diálogos y snackbars sin cambios para mantener funcionalidad -->

    <v-dialog v-model="mostrarRegistrarVisita" max-width="600px" v-if="miembro">
      <v-card>
        <v-card-title class="headline">
          ¿Es correcta la visita de {{ miembro.nombre }}?
        </v-card-title>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="red darken-1" text @click="cerrarDialogo">Cancelar</v-btn>
          <v-btn color="primary" text :loading="cargando" :disabled="cargando" @click="registrar">
            Registrar
            <template v-slot:loader>
              <span>Registrando</span>
            </template>
          </v-btn>
          <v-spacer></v-spacer>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-dialog v-model="mostrarRealizarPago" persistent max-width="600">
      <realizar-pago :matricula="matricula" @cerrar="cerrarDialogoPago" @pagado="onPagado" />
    </v-dialog>

    <v-snackbar v-model="mostrarMensaje" :timeout="3000" :color="mensaje.color" top>
      {{ mensaje.texto }}
    </v-snackbar>

    <v-dialog v-model="mostrarDialogoRegular" persistent max-width="600px">
      <v-card>
        <v-card-title class="headline">Registro visita regular</v-card-title>
        <v-card-text>
          <v-container>
            <v-text-field label="Escribe el pago por una visita regular" v-model="pagoVisita" required
              outlined></v-text-field>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="primary" text @click="mostrarDialogoRegular = false">Cerrar</v-btn>
          <v-btn color="primary" text :loading="cargando" :disabled="cargando" @click="registrarVisitaRegular">
            Registrar
            <template v-slot:loader>
              <span>Registrando</span>
            </template>
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<style scoped>
.miembros {
  padding: 40px 20px;
  background-color: #121212;
  min-height: 100vh;
  color: #e0e0e0;
  font-family: "Roboto", sans-serif;
}

.card-regular {
  background-color: #1f1f1f;
  border-radius: 20px;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.6);
}

.card-miembro {
  background-color: #222222;
  border-radius: 16px;
  overflow: hidden;
  color: #ffffff;
  width: 100%;
  max-width: 400px;
}

.card-miembro .v-img {
  border-bottom-left-radius: 0;
  border-bottom-right-radius: 0;
}

.headline {
  font-weight: 600;
  font-size: 1.5rem;
}

h3 {
  color: #f0f0f0;
}

.v-btn {
  box-shadow: 0 4px 10px rgb(0 0 0 / 0.3);
  transition: background-color 0.3s ease;
}

.v-btn:hover {
  filter: brightness(1.1);
}

.v-chip {
  font-weight: 600;
  font-size: 1rem;
  text-transform: uppercase;
}

@media (max-width: 600px) {
  .card-regular {
    padding: 24px !important;
  }

  h3 {
    font-size: 1.1rem;
  }
}
</style>

<script>
import BusquedaMiembro from "../Miembros/BusquedaMiembro.vue";
import RealizarPago from "../Miembros/RealizarPago.vue";
import Utiles from "../../Servicios/Utiles";
import HttpService from "../../Servicios/HttpService";

export default {
  name: "RegistrarVisita",
  components: { BusquedaMiembro, RealizarPago },

  data: () => ({
    miembro: null,
    mostrarRegistrarVisita: false,
    mostrarRealizarPago: false,
    mostrarDialogoRegular: false,
    cargando: false,
    mensaje: {},
    mostrarMensaje: false,
    matricula: "",
    pagoVisita: ""
  }),

  methods: {
    registrarVisitaRegular() {
      if (!this.pagoVisita) return
      console.log(this.pagoVisita)
      this.cargando = true
      HttpService.registrar({
        metodo: 'registrar_regular',
        visita: { idUsuario: localStorage.getItem('idUsuario'), pago: this.pagoVisita }
      }, 'visitas.php')
        .then(resultado => {
          if (resultado) {
            this.cargando = false
            this.mostrarDialogoRegular = false
            this.mostrarMensaje = true
            this.mensaje = {
              texto: "Visita regular registrada",
              color: "success"
            }
          }
        })
    },

    abrirRealizarPago() {
      this.matricula = this.miembro.matricula;
      this.mostrarRealizarPago = true;
    },

    onPagado(resultado) {
      if (resultado) {
        this.mostrarRealizarPago = false;
        this.mostrarMensaje = true;
        this.mensaje = {
          color: "success",
          texto: "Pago realizado con éxito. Puedes realizar la visita.",
        };
        this.miembro = null;
      }
    },

    cerrarDialogoPago() {
      this.mostrarRealizarPago = false;
    },

    cerrarDialogo() {
      this.mostrarRegistrarVisita = false;
    },

    registrar() {
      this.cargando = true;
      let payload = {
        metodo: "registrar",
        visita: {
          idMiembro: this.miembro.id,
          idMembresia: this.miembro.idMembresia,
          idUsuario: localStorage.getItem("idUsuario"),
        },
      };

      HttpService.registrar(payload, "visitas.php").then((resultado) => {
        if (resultado) {
          this.mostrarMensaje = true;
          this.mensaje = {
            texto: "Visita registrada",
            color: "success",
          };

          this.miembro = null;
          this.mostrarRegistrarVisita = false;
          this.cargando = false;
        }
      });
    },

    abrirRegistrarVisita() {
      this.mostrarRegistrarVisita = true;
    },

    urlImagen(imagen) {
      return Utiles.generarURL(imagen);
    },

    onMiembroSeleccionado(miembro) {
      this.miembro = miembro;
    },

    estado(val) {
      return val === "ACTIVO"
        ? "success"
        : val === "VENCIDO"
          ? "error"
          : "warning";
    },
  },
};
</script>
