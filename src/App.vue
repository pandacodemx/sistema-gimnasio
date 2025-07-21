<template>
  <div id="app">
    <v-app>
      <login @logeado="onLog" v-if="!isLoggedIn" />
      <cambiar-password v-if="debeCambiarPassword" />
      <div v-if="isLoggedIn && !debeCambiarPassword">
        <encabezado />
        <v-main>
          <v-container fluid>
            <router-view />
            <pie-component />
          </v-container>
        </v-main>
      </div>

      <v-snackbar v-model="mostrarMensaje" :timeout="3000" :color="mensaje.color" top>
        {{ mensaje.texto }}
      </v-snackbar>

      <v-snackbar v-model="$store.state.snackbar.mostrar" :color="$store.state.snackbar.color" timeout="3000" bot
        center>
        {{ $store.state.snackbar.mensaje }}
        <template v-slot:action="{ attrs }">
          <v-btn color="white" text v-bind="attrs" @click="$store.commit('ocultarSnackbar')">Cerrar</v-btn>
        </template>
      </v-snackbar>
    </v-app>
  </div>
</template>


<script>
import Encabezado from './components/Encabezado.vue'
import Login from './components/Usuarios/Login.vue'
import CambiarPassword from './components/Usuarios/CambiarPassword.vue'
import PieComponent from './components/Dialogos/PieComponent.vue'
import HttpService from './Servicios/HttpService'
import { mapGetters, mapMutations } from "vuex";

export default {
  name: 'App',
  components: { Encabezado, Login, CambiarPassword, PieComponent },

  data() {
    return {
      mostrarMensaje: false,
      mensaje: {
        texto: "",
        color: ""
      }
    }
  },

  computed: {
    ...mapGetters(["isLoggedIn", "debeCambiarPassword"])
  },

  mounted() {
    this.obtenerInformacionNegocio();
  },

  methods: {
    ...mapMutations(["setUser", "setDebeCambiarPassword"]),

    onLog(respuesta) {
      if (!respuesta.resultado) {
        this.mostrarMensaje = true;
        this.mensaje = {
          texto: "Datos incorrectos, verifica la información",
          color: "error"
        };
        return;
      }

      if (respuesta.resultado === "cambia") {
        this.mostrarMensaje = true;
        this.mensaje = {
          texto: "Datos correctos. Por favor cambia tu contraseña",
          color: "indigo"
        };
        this.setDebeCambiarPassword(true);
        this.setUser(respuesta.datos);
        return;
      }

      if (respuesta.resultado) {
        this.setUser(respuesta.datos);
        this.setDebeCambiarPassword(false);
        this.mostrarMensaje = true;
        this.mensaje = {
          texto: "Ingreso correcto",
          color: "success"
        };
        this.$router.push({ name: "InicioComponent" });
      }
    },

    obtenerInformacionNegocio() {
      HttpService.obtenerConDatos({ metodo: 'obtener' }, 'ajustes.php')
        .then(resultado => {
          localStorage.setItem("nombreGimnasio", resultado.nombre)
          localStorage.setItem("logoGimnasio", resultado.logo)
          localStorage.setItem("telefonoGimnasio", resultado.telefono)
          localStorage.setItem("direccionGimnasio", resultado.direccion)
        })
    }
  }
}
</script>


<style>
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap');

/* Aplica la fuente a toda la app */
body,
.v-application {
  font-family: 'Poppins', sans-serif !important;
  margin: 0;
  padding: 0;
  background-color: #121212;
  color: #fff;
}
</style>