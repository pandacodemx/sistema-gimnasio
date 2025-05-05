<template>
  <div class="login-background animated-bg">
    <div class="overlay-left"></div>
    <div class="overlay-right">
      <v-container fluid class="fill-height pa-0 d-flex align-center justify-center">
        <transition name="fade-slide">
          <v-card class="glass-card rounded-xl px-4 py-6" max-width="400">
            <v-toolbar flat class="bg-teal-darken-4 mb-4">
              <v-toolbar-title class="text-white">Iniciar Sesión</v-toolbar-title>
            </v-toolbar>

            <!-- Logotipo -->
            <div class="d-flex justify-center mb-4">
              <v-img
                src="https://static.vecteezy.com/system/resources/thumbnails/044/812/143/small_2x/dynamic-fitness-gym-logo-on-transparent-background-png.png"
                contain
                width="80"
                height="80"
                class="logo"
              ></v-img>
            </div>

            <v-card-text>
              <v-form>
                <v-text-field
                  prepend-inner-icon="mdi-account"
                  label="Usuario"
                  v-model="usuario"
                  outlined
                  dense
                  color="teal"
                />
                <v-text-field
                  prepend-inner-icon="mdi-lock"
                  label="Contraseña"
                  type="password"
                  v-model="password"
                  outlined
                  dense
                  color="teal"
                />
              </v-form>
            </v-card-text>
            <v-card-actions class="px-4 pb-2">
              <v-spacer />
              <v-btn color="teal-darken-2" dark @click="iniciarSesion">Ingresar</v-btn>
            </v-card-actions>
          </v-card>
        </transition>
      </v-container>
    </div>

    <!-- Snackbar para mensajes -->
    <v-snackbar
      v-model="mostrarMensaje"
      :multi-line="multiLine"
      :timeout="3000"
      :color="mensaje.color"
      right
      shaped
      top
    >
      {{ mensaje.texto }}
      <template v-slot:action="{ attrs }">
        <v-btn color="blackbox" text v-bind="attrs" @click="mostrarMensaje = false">
          Cerrar
        </v-btn>
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
              usuario:this.usuario,
              password: this.password
          }
      }
      HttpService.obtenerConDatos(payload, "usuarios.php")
      .then(resultado => {
          if(resultado) {
              this.$emit("logeado", resultado)
          }
      })

      
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

/* Mitad izquierda sin efectos */
.overlay-left {
  flex: 1;
}

/* Mitad derecha con blur y oscuridad */
.overlay-right {
  flex: 1;
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  background-color: rgba(0, 0, 0, 0.4);
  display: flex;
  justify-content: center;
  align-items: center;
}

.glass-card {
  background: rgba(255, 255, 255, 0.06);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.15);
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
</style>