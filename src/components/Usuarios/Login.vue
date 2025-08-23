<template>
  <div class="login-background animated-bg">
    <!-- HEADER -->
    <v-app-bar flat dense class="blur-header">

      <v-spacer />
      <v-btn text icon color="white" @click="abrirSoporte">
        <v-icon>mdi mdi-cellphone</v-icon>
      </v-btn>
      <v-btn text icon color="white" @click="abrirContacto">
        <v-icon>mdi-email</v-icon>
      </v-btn>
    </v-app-bar>

    <!-- CONTENIDO PRINCIPAL - DISEÑO DIVIDIDO -->
    <div class="login-container">
      <!-- Sección de información del sistema (izquierda) -->
      <div class="system-info-section" style="background: rgba(0, 0, 0, 0.8); backdrop-filter: blur(5px);">
        <div class="system-info-content">
          <div class="logo-container">
            <v-img src="https://i.ibb.co/tpBKypzH/LOGOBAMBO.png" contain width="320" class="elevation-3"></v-img>
          </div>

          <h1 class="system-name">Sistema de Gestión de Gimnasio</h1>
          <p class="system-description">
            Plataforma integral para administración de membresías, control de acceso
            y seguimiento de clientes en tu centro deportivo.
          </p>

          <div class="features-list">
            <div class="feature-item">
              <v-icon color="teal lighten-1" class="mr-2">mdi-account-multiple</v-icon>
              Gestión de miembros y clientes
            </div>
            <div class="feature-item">
              <v-icon color="teal lighten-1" class="mr-2">mdi-credit-card</v-icon>
              Control de pagos y membresías
            </div>
            <div class="feature-item">
              <v-icon color="teal lighten-1" class="mr-2">mdi-chart-bar</v-icon>
              Reportes y estadísticas
            </div>
            <div class="feature-item">
              <v-icon color="teal lighten-1" class="mr-2">mdi-security</v-icon>
              Control de acceso seguro
            </div>
          </div>

          <div class="version-info mb-5">
            Versión 1.5 - Bamboo Management Suite
          </div>
        </div>
      </div>

      <!-- Sección de formulario (derecha) -->
      <div class="form-section">
        <transition name="fade-slide">
          <v-card class="login-form-card rounded-xl px-6 py-8" max-width="450"
            style="background: rgba(0, 0, 0, 0.5); backdrop-filter: blur(25px); border: 1px solid rgba(255, 255, 255, 0.2);">
            <div class="logo-container mb-6 d-flex">
              <v-img
                src="https://static.vecteezy.com/system/resources/thumbnails/044/812/143/small_2x/dynamic-fitness-gym-logo-on-transparent-background-png.png"
                contain width="160" height="160" class="elevation-3"></v-img>
            </div>
            <v-toolbar flat class="mb-6 transparent">
              <v-toolbar-title class="text-white font-weight-bold" style="font-size: 1.8rem;">Iniciar
                Sesión</v-toolbar-title>
            </v-toolbar>

            <v-card-text class="px-4">
              <v-form>
                <v-text-field prepend-inner-icon="mdi-account" label="Usuario" v-model="usuario" outlined dense
                  color="teal lighten-1" class="mb-4" background-color="rgba(255,255,255,0.1)" dark />
                <v-text-field prepend-inner-icon="mdi-lock" label="Contraseña" type="password" v-model="password"
                  outlined dense color="teal lighten-1" background-color="rgba(255,255,255,0.1)" dark />
              </v-form>
            </v-card-text>

            <v-card-actions class="px-4 pb-3">
              <v-spacer />
              <v-btn color="teal lighten-1" dark @click="iniciarSesion" large rounded
                class="px-8 font-weight-bold login-btn" style="letter-spacing: 1px;">
                Ingresar
              </v-btn>
            </v-card-actions>

            <div class="support-links px-4 mt-6">
              <v-btn text small color="teal lighten-3" @click="abrirSoporte" class="mr-3">
                <v-icon small left>mdi-help-circle</v-icon>
                Soporte
              </v-btn>
              <v-btn text small color="teal lighten-3" @click="abrirContacto">
                <v-icon small left>mdi-email</v-icon>
                Contacto
              </v-btn>
            </div>
          </v-card>
        </transition>
      </div>
    </div>

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
  flex-direction: column;

}

.login-container {
  display: flex;
  height: 100%;
  width: 100%;
}

.system-info-section {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px;
  color: white;
  position: relative;
}

.system-info-content {
  max-width: 600px;
  z-index: 2;
}

.system-name {
  font-size: 2.2rem;
  font-weight: 700;
  margin-bottom: 20px;
  text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.5);
}

.system-description {
  font-size: 1.1rem;
  line-height: 1.6;
  margin-bottom: 30px;
  opacity: 0.9;
}

.features-list {
  margin: 30px 0;
}

.feature-item {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
  font-size: 1rem;
}

.version-info {
  position: absolute;
  bottom: 40px;
  left: 40px;
  background: rgba(255, 255, 255, 0.2);
  padding: 6px 16px;
  border-radius: 20px;
  font-size: 0.85rem;
}

.form-section {
  width: 50%;
  min-width: 500px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(10px);
}

.login-form-card {
  width: 100%;
  max-width: 450px;
}

.support-links {
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding-top: 20px;
}

/* Efectos y animaciones */
.v-btn:hover {
  transform: translateY(-2px);
  transition: all 0.3s ease;
}

.v-text-field:hover .v-input__control {
  transform: scale(1.02);
  transition: all 0.3s ease;
}

.v-app-bar .v-btn:hover {
  background: rgba(255, 255, 255, 0.1) !important;
  transform: rotate(10deg);
}

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

/* Responsive */
@media (max-width: 960px) {
  .login-container {
    flex-direction: column;
  }

  .system-info-section {
    display: none;
  }

  .form-section {
    width: 100%;
    min-width: auto;
    background: rgba(0, 0, 0, 0.7);
  }
}
</style>