<template>
  <div>
    <v-card>
      <v-card-title>
        <span>Realizar pago para {{ matricula }}</span>
      </v-card-title>
      <v-alert shaped prominent type="error">
        Atencion! Revise atentamente la membresia seleccionada, una vez guardada no hay forma de ser modificada.
      </v-alert>
      <v-card-text>
        <v-container>
          <v-select v-model="membresiaSeleccionada"
            :hint="`${membresiaSeleccionada.nombre} | $${membresiaSeleccionada.precio} | ${membresiaSeleccionada.duracion} Dias`"
            :items="membresias" item-text="nombre" item-value="id" label="Selecciona una membresía" persistent-hint
            return-object single-line>
          </v-select>
          <v-row class="mt-5 justify-center">
            <v-date-picker v-model="fechaSeleccionada" :first-day-of-week="1" locale="es-se"
              type="date"></v-date-picker>
          </v-row>
        </v-container>
      </v-card-text>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="primary" text @click="cerrarDialogo">
          Cerrar
        </v-btn>
        <v-btn color="white" text @click="realizarPago">
          Registrar
        </v-btn>
      </v-card-actions>
    </v-card>
    <v-overlay :value="cargando">
      <v-progress-circular indeterminate size="64"></v-progress-circular>
    </v-overlay>

  </div>

</template>
<script>
import HttpService from '../../Servicios/HttpService'
export default {
  name: "RealizarPago",
  props: ["matricula"],

  data: () => ({
    membresiaSeleccionada: { id: "", nombre: "", precio: "", duracion: "" },
    fechaSeleccionada: new Date(
      Date.now() - new Date().getTimezoneOffset() * 60000
    )
      .toISOString()
      .substr(0, 10),
    membresias: [],
    cargando: false
  }),

  mounted() {
    this.obtenerMembresias();
  },

  methods: {
    obtenerMembresias() {
      const payload = { metodo: "get" };
      HttpService.obtenerConDatos(payload, "membresias.php").then(
        (respuesta) => {
          this.membresias = respuesta;
        }
      );
    },

    cerrarDialogo() {
      this.$emit("cerrar", false)
    },

    realizarPago() {
      if (!this.membresiaSeleccionada) return;
      this.cargando = true;

      // Obtener fecha seleccionada con hora actual
      const fechaSeleccionada = new Date(this.fechaSeleccionada);
      const ahora = new Date();
      fechaSeleccionada.setHours(ahora.getHours());
      fechaSeleccionada.setMinutes(ahora.getMinutes());
      fechaSeleccionada.setSeconds(ahora.getSeconds());

      // Formato: "YYYY-MM-DD HH:MM:SS" (hora local)
      const formatDateTime = (date) => {
        const pad = num => num.toString().padStart(2, '0');
        return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())} ` +
          `${pad(date.getHours())}:${pad(date.getMinutes())}:${pad(date.getSeconds())}`;
      };

      let payload = {
        metodo: 'pagar',
        pago: {
          matricula: this.matricula,
          pago: this.membresiaSeleccionada.precio,
          idMembresia: this.membresiaSeleccionada.id,
          duracion: this.membresiaSeleccionada.duracion,
          fecha: formatDateTime(fechaSeleccionada),
          idUsuario: localStorage.getItem('idUsuario')
        }
      };

      HttpService.registrar(payload, "miembros.php")
        .then((registrado) => {
          this.cargando = false;
          if (registrado) {
            this.$emit("pagado", registrado);
          }
        });
    }

  }
};
</script>