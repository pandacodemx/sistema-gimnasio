<template>
  <div class="login-container">
    <v-container fluid class="fill-height pa-0">
      <v-row no-gutters class="fill-height">
        <!-- Imagen lateral -->
        <v-col cols="12" md="6" class="image-side"></v-col>

        <!-- Formulario con efecto glass -->
        <v-col
          cols="12"
          md="6"
          class="d-flex align-center justify-center"
        >
          <transition name="fade-slide">
            <v-card class="glass-card rounded-xl px-4 py-6" max-width="400">
              <v-toolbar flat class="bg-teal-darken-4 mb-4">
                <v-toolbar-title class="text-white">Iniciar sesión / Sistema Gym</v-toolbar-title>
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
        </v-col>
      </v-row>

      <!-- Snackbar para mensajes -->
      <v-snackbar
        v-model="mostrarMensaje"
        :timeout="3000"
        :color="mensaje.color"
        top
      >
        {{ mensaje.texto }}
      </v-snackbar>
    </v-container>
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
    mostrarMensaje: false
  }),

  methods: {
    iniciarSesion() {
      if (!this.usuario) {
          this.mostrarMensaje = true
          this.mensaje.texto = "Ingresa datos de usuario"
          this.mensaje.color = "warning"
          return
      }
      if (!this.password) {
          this.mostrarMensaje = true
          this.mensaje.texto = "Ingresa la contraseña"
          this.mensaje.color = "warning"
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
.login-container {
  height: 100vh;
  overflow: hidden;
}

.image-side {
  background-image: url("https://images.unsplash.com/photo-1571902943202-507ec2618e8f?fm=jpg&q=60&w=3000");
  background-size: cover;
  background-position: center;
}

.glass-card {
  background: rgba(17, 104, 107, 0.08);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
  border: 1px solid rgba(255, 255, 255, 0.2);
  
}

/* Animación suave */
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
</style>
