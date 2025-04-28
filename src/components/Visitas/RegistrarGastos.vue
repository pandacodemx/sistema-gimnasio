<template>
    <div>
      <v-progress-linear :active="cargando" :indeterminate="cargando" absolute top color="primary"></v-progress-linear>
  
      <v-snackbar v-model="mostrarMensaje" :timeout="3000" :color="mensaje.color" top>
        {{ mensaje.texto }}
      </v-snackbar>
  
      <h1>Registrar Gasto</h1>
  
      <v-form @submit.prevent="registrarGasto">
        <v-text-field v-model="gasto.descripcion" label="Descripción del gasto" required />
        <v-text-field v-model="gasto.monto" label="Monto" type="number" required />
        <v-btn type="submit" color="primary">Registrar gasto</v-btn>
      </v-form>
    </div>
  </template>
  
  <script>
  import HttpService from "../../Servicios/HttpService";
  
  export default {
    name: "RegistrarGasto",
    data: () => ({
      cargando: false,
      gasto: {
        descripcion: '',
        monto: null
      },
      mostrarMensaje: false,
      mensaje: {
        texto: '',
        color: ''
      }
    }),
    methods: {
      registrarGasto() {
        this.cargando = true;
  
        const payload = {
          metodo: 'registrarGasto',
          gasto: this.gasto
        };
  
        HttpService.registrar(payload, "gastos.php")
          .then(resultado => {
            if (resultado) {
              this.mostrarMensaje = true;
              this.mensaje.texto = "Gasto registrado exitosamente.";
              this.mensaje.color = "success";
              this.gasto.descripcion = '';
              this.gasto.monto = null;
            } else {
              this.mostrarMensaje = true;
              this.mensaje.texto = "Error al registrar gasto.";
              this.mensaje.color = "error";
            }
            this.cargando = false;
          });
      }
    }
  }
  </script>
  