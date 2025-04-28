<template>
    <v-container>
      <h2>Cambiar contraseña de usuario</h2>
      <v-form ref="form" v-model="formValido">
        <v-card elevation="5" class="mx-auto">
          <v-card-text>
            <v-text-field
              v-model="nuevaPassword"
              :append-icon="mostrarNueva ? 'mdi-eye' : 'mdi-eye-off'"
              :rules="[rules.required, rules.min]"
              :type="mostrarNueva ? 'text' : 'password'"
              label="Nueva contraseña"
              counter
              @click:append="mostrarNueva = !mostrarNueva"
            />
            <v-text-field
              v-model="repitePassword"
              :append-icon="mostrarRepetida ? 'mdi-eye' : 'mdi-eye-off'"
              :rules="[rules.required, rules.min]"
              :type="mostrarRepetida ? 'text' : 'password'"
              label="Repetir contraseña"
              counter
              @click:append="mostrarRepetida = !mostrarRepetida"
            />
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="primary" @click="cambiarPassword" :disabled="!formValido">Actualizar</v-btn>
          </v-card-actions>
        </v-card>
      </v-form>
      <v-snackbar v-model="mostrarMensaje" :timeout="3000" :color="mensaje.color" top>
        {{ mensaje.texto }}
      </v-snackbar>
    </v-container>
  </template>
  
  <script>
  import HttpService from "../../Servicios/HttpService";
  
  export default {
    name: "FormCambiarPassword",
    props: {
      idUsuario: {
        type: Number,
        required: true
      }
    },
    data: () => ({
      formValido: false,
      nuevaPassword: "",
      repitePassword: "",
      mostrarNueva: false,
      mostrarRepetida: false,
      mostrarMensaje: false,
      mensaje: {
        texto: "",
        color: "",
      },
      rules: {
        required: v => !!v || "Debes colocar este dato.",
        min: v => v.length >= 8 || "Mínimo 8 caracteres",
      },
    }),
    methods: {
      cambiarPassword() {
        if (this.nuevaPassword !== this.repitePassword) {
          this.mostrarMensaje = true;
          this.mensaje = {
            texto: "Las contraseñas no coinciden",
            color: "error",
          };
          return;
        }
  
        const payload = {
          metodo: "cambiar_pass",
          idUsuario: this.idUsuario,
          password: this.repitePassword,
        };
  
        HttpService.registrar(payload, "usuarios.php").then(resultado => {
          if (resultado) {
            this.mostrarMensaje = true;
            this.mensaje = {
              texto: "Contraseña actualizada correctamente",
              color: "success",
            };
            this.nuevaPassword = "";
            this.repitePassword = "";
          }
        });
      }
    }
  };
  </script>
  