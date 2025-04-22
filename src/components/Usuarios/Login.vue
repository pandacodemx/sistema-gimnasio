<template>
  <div class="fondo">
    <v-container fluid fill-height>
    <v-layout align-center justify-center>
      <v-flex xs12 sm8 md4>
        <v-card class="elevation-12 rounded-lg " height="100%">
          <v-toolbar color="primary" class="bg-teal">
            <v-toolbar-title>Iniciar sesión / Sistema Gym</v-toolbar-title>
          </v-toolbar>
          <v-card-text>
            <v-form>
              <v-text-field
                prepend-icon="person"
                name="login"
                label="Usuario"
                type="text"
                v-model="usuario"
              ></v-text-field>
              <v-text-field
                id="password"
                prepend-icon="lock"
                name="password"
                label="Contraseña"
                type="password"
                v-model="password"
              ></v-text-field>
            </v-form>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="primary" @click="iniciarSesion">Ingresar</v-btn>
          </v-card-actions>
        </v-card>
      </v-flex>

    </v-layout>
    <v-snackbar
        v-model="mostrarMensaje"
        :timeout="3000"
        :color="mensaje.color"
        top
        >
        {{ mensaje.texto }}
    </v-snackbar>
    </v-container>
    <img src="" alt="">

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
<style >
.fondo{
  background-color: #0d0d0e;
  background-image: url("https://images.unsplash.com/photo-1571902943202-507ec2618e8f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Z3ltfGVufDB8fDB8fHww");
  background-attachment: fixed;
  background-size: cover;
  height: 100vh;
}
</style>