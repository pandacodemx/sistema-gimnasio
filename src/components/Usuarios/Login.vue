<template>
  <div class="login-background animated-bg">
    <!-- HEADER -->
    <v-app-bar flat dense class="blur-header">
      <v-toolbar-title class="text-white txt-12">Sistema de Gimnasio V1.5</v-toolbar-title>
      <v-spacer />
      <v-btn text icon color="white" @click="abrirSoporte">
        <v-icon>mdi mdi-cellphone</v-icon>
      </v-btn>
      <v-btn text icon color="white" @click="abrirContacto">
        <v-icon>mdi-email</v-icon>
      </v-btn>
    </v-app-bar>

    <!-- CONTENIDO PRINCIPAL -->
    <v-container fluid class="fill-height pa-0 d-flex align-center justify-center">
      <transition name="fade-slide">
        <v-card class="rounded-xl px-4 py-6" max-width="400"
          style="background: rgba(0, 0, 0, 0.6); backdrop-filter: blur(25px); border: 1px solid rgba(255, 255, 255, 0.2);">
          <v-toolbar flat class="mb-4 transparent">
            <v-toolbar-title class="text-white font-weight-bold" style="font-size: 1.5rem;">Iniciar
              Sesión</v-toolbar-title>
          </v-toolbar>

          <div class="d-flex justify-center mb-4">
            <v-img src="https://i.ibb.co/pBRCQvhh/Logotipo-Bonito.png" contain width="180" height="180"
              class="elevation-3"></v-img>
          </div>

          <v-card-text class=" px-4">
            <v-form>
              <v-text-field prepend-inner-icon="mdi-account" label="Usuario" v-model="usuario" outlined dense
                color="white" class="mb-3" background-color="rgba(255,255,255,0.1)" dark />
              <v-text-field prepend-inner-icon="mdi-lock" label="Contraseña" type="password" v-model="password" outlined
                dense color="white" background-color="rgba(255,255,255,0.1)" dark />
            </v-form>
          </v-card-text>

          <v-card-actions class="px-4 pb-2">
            <v-spacer />
            <v-btn color="teal lighten-1" dark @click="iniciarSesion" large rounded class="px-6 font-weight-bold"
              style="letter-spacing: 1px;">
              Ingresar
            </v-btn>
          </v-card-actions>
        </v-card>
      </transition>
    </v-container>

    <!-- FOOTER -->
    <v-footer app padless class="blur-footer text-white d-flex justify-center" style="height: 50px;">
      <div class="txt-12 py-2 px-4 d-flex align-center">
        <v-icon small class="mr-2">mdi-code-braces</v-icon>
        Desarrollado por PandaCode © {{ new Date().getFullYear() }}
      </div>
    </v-footer>

    <!-- Snackbar -->
    <v-snackbar v-model="mostrarMensaje" :multi-line="multiLine" :timeout="3000" :color="mensaje.color" right shaped
      top>
      {{ mensaje.texto }}
      <template v-slot:action="{ attrs }">
        <v-btn color="blackbox" text v-bind="attrs" @click="mostrarMensaje = false">Cerrar</v-btn>
      </template>
    </v-snackbar>
  </div>
</template>




<script>
import HttpService from '../../Servicios/HttpService'

export default {
  name: "Login",

  data: () => ({
    usuario: "",
    password: "",
    mensaje: {
      texto: "",
      color: "",
    },
    mostrarMensaje: false,
    multiLine: true,
  }),

  created() {
    if (this.$store.getters.isLoggedIn) {
      this.redireccionarPorRol(this.$store.getters.userRole);
    }
  },

  methods: {
    iniciarSesion() {
      if (!this.usuario || !this.password) {
        this.mostrarMensaje = true;
        this.mensaje.texto = !this.usuario
          ? "Debes colocar el usuario"
          : "Debes colocar la contraseña";
        this.mensaje.color = "warning";
        return;
      }

      const payload = {
        metodo: "login",
        usuario: {
          usuario: this.usuario,
          password: this.password,
        },
      };

      HttpService.obtenerConDatos(payload, "usuarios.php")
        .then((resultado) => {
          if (resultado && resultado.resultado) {
            const rol = resultado.datos.rol.toLowerCase();
            localStorage.setItem("idUsuario", resultado.datos.idUsuario);
            localStorage.setItem("rol", resultado.datos.rol);
            localStorage.setItem("usuario", resultado.datos.nombreUsuario);

            this.$store.commit("setUser", resultado.datos);
            this.redireccionarPorRol(rol);
          } else {
            this.mostrarMensaje = true;
            this.mensaje.texto = "Usuario o contraseña incorrectos";
            this.mensaje.color = "error";
          }
        });
    },

    redireccionarPorRol(rol) {
      switch (rol) {
        case "admin":
        case "administrador":
          this.$router.replace("/dashboard");
          break;
        case "empleado":
          this.$router.replace("/registrar-visita");
          break;
        default:
          this.mostrarMensaje = true;
          this.mensaje.texto = "No tienes permisos para acceder.";
          this.mensaje.color = "error";
      }
    },

    abrirSoporte() {
      this.mostrarMensaje = true;
      this.mensaje.texto = "Envíanos un mensaje a nava.saidalfredo@gmail.com";
      this.mensaje.color = "info";
    },

    abrirContacto() {
      this.mostrarMensaje = true;
      this.mensaje.texto = "Contáctanos mediante Whatsapp al 3531015780";
      this.mensaje.color = "error";
    },
  },
};
</script>


<style scoped>
.login-background {
  position: relative;
  height: 100vh;
  width: 100vw;
  background-image: url("https://bonitogym.com.mx/api/uploads/bg_login.webp");
  background-size: cover;
  background-position: center;
  overflow: hidden;
  display: flex;
}

.v-btn:hover {
  transform: translateY(-2px);
  transition: all 0.3s ease;
}

.v-text-field:hover .v-input__control {
  transform: scale(1.02);
  transition: all 0.3s ease;
}

/* Efecto para los iconos de contacto */
.v-app-bar .v-btn:hover {
  background: rgba(255, 255, 255, 0.1) !important;
  transform: rotate(10deg);
}

/* Animación */
.fade-slide-enter-active {
  animation: fadeSlideIn 0.6s ease-out both;
}

@keyframes fadeSlideIn {
  0% {
    opacity: 0;
    transform: translateY(30px);
  }

  100% {
    opacity: 1;
    transform: translateY(0);
  }
}

.animated-bg {
  animation: fadeZoomIn 1s ease-out both;
}

@keyframes fadeZoomIn {
  0% {
    opacity: 0;
    transform: scale(1.05);
  }

  100% {
    opacity: 1;
    transform: scale(1);
  }
}

.blur-header,
.blur-footer {
  backdrop-filter: blur(30px);
  -webkit-backdrop-filter: blur(30px);
  background-color: rgba(0, 0, 0, 0.5);
  position: fixed;
  width: 100%;
  z-index: 10;
}

.blur-header {
  top: 0;
}

.blur-footer {
  bottom: 0;
}

.txt-12 {
  font-size: 12px;
}
</style>