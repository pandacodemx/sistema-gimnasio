<template>
  <div class="login-background animated-bg">
    <!-- HEADER -->
    <v-app-bar flat dense class="blur-header">
      <v-toolbar-title class="text-white txt-12">Sistema de Gimnasio V1.0</v-toolbar-title>
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
        <v-card class="rounded-xl px-4 py-6" max-width="400">
          <v-toolbar flat class="mb-4">
            <v-toolbar-title class="text-white" color="teal">Iniciar Sesión</v-toolbar-title>
          </v-toolbar>

          <div class="d-flex justify-center mb-4">
            <v-img src="https://i.ibb.co/pBRCQvhh/Logotipo-Bonito.png" contain width="150" height="150"></v-img>
          </div>

          <v-card-text>
            <v-form>
              <v-text-field prepend-inner-icon="mdi-account" label="Usuario" v-model="usuario" outlined dense
                color="teal" />
              <v-text-field prepend-inner-icon="mdi-lock" label="Contraseña" type="password" v-model="password" outlined
                dense color="teal" />
            </v-form>
          </v-card-text>

          <v-card-actions class="px-4 pb-2">
            <v-spacer />
            <v-btn color="teal-darken-2" dark @click="iniciarSesion">Ingresar</v-btn>
          </v-card-actions>
        </v-card>
      </transition>
    </v-container>

    <!-- FOOTER -->
    <v-footer app padless class="blur-footer text-white d-flex justify-center">
      <div class="txt-12 py-2 px-4">Desarrollado por PandaCode © {{ new Date().getFullYear() }}</div>
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

  methods: {
    iniciarSesion() {
      if (!this.usuario) {
        this.mostrarMensaje = true
        this.mensaje.texto = "Atencion! Campos vacios"
        this.mensaje.color = "error"
        return
      }
      if (!this.password) {
        this.mostrarMensaje = true
        this.mensaje.texto = "Error! Ingresa la contraseña"
        this.mensaje.color = "error"
        return
      }
      let payload = {
        metodo: "login",
        usuario: {
          usuario: this.usuario,
          password: this.password
        }
      }
      HttpService.obtenerConDatos(payload, "usuarios.php")
        .then(resultado => {
          if (resultado) {
            this.$emit("logeado", resultado)
          }
        })
    },
    abrirSoporte() {
      this.mostrarMensaje = true;
      this.mensaje.texto = "Envíanos un mensaje a nava.saidalfredo@gmail.com";
      this.mensaje.color = "info";
    },
    abrirContacto() {
      this.mostrarMensaje = true;
      this.mensaje.texto = "Contáctanos en contacto@sistema.com";
      this.mensaje.color = "info";
    },
  },
};
</script>
<style scoped>
.login-background {
  position: relative;
  height: 100vh;
  width: 100vw;
  background-image: url("https://images.unsplash.com/photo-1571902943202-507ec2618e8f?fm=jpg&q=60&w=3000");
  background-size: cover;
  background-position: center;
  overflow: hidden;
  display: flex;
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