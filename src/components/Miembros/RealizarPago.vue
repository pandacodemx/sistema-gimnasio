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
        <v-btn color="white" text @click="confirmarPago">
          Registrar
        </v-btn>
      </v-card-actions>
    </v-card>
    <!--DIALOGO DE CONFIRMAICON FECHA -->
    <v-dialog v-model="mostrarConfirmacionFecha" max-width="500px" persistent>
      <v-card>
        <v-card-title class="headline error">
          <v-icon color="warning" class="mr-2">mdi-alert</v-icon>
          Confirmar fecha diferente
        </v-card-title>

        <v-card-text class="pt-4">
          <p>Estás seleccionando una fecha diferente al día actual:</p>
          <p><strong>Fecha seleccionada:</strong> {{ fechaSeleccionadaFormateada }}</p>
          <p><strong>Fecha actual:</strong> {{ fechaActualFormateada }}</p>
          <p class="red--text">¿Estás seguro de que deseas continuar?</p>
        </v-card-text>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="grey" text @click="mostrarConfirmacionFecha = false">
            Cancelar
          </v-btn>
          <v-btn color="primary" text @click="realizarPagoConfirmado">
            Confirmar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
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
    fechaSeleccionada: new Date().toISOString().split('T')[0],
    membresias: [],
    cargando: false,
    mostrarConfirmacionFecha: false,
  }),
  computed: {
    fechaSeleccionadaFormateada() {
      if (!this.fechaSeleccionada) return '';
      const [year, month, day] = this.fechaSeleccionada.split('-');
      const fechaLocal = new Date(year, month - 1, day);

      return fechaLocal.toLocaleDateString('es-MX', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric',
        timeZone: 'America/Mexico_City'
      });
    },

    fechaActualFormateada() {
      const ahora = new Date();
      return ahora.toLocaleDateString('es-MX', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric',
        timeZone: 'America/Mexico_City'
      });
    }
  },


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

    esFechaDiferente() {

      const fechaSelec = this.fechaSeleccionada;
      const hoy = new Date();
      const hoyFormateado = hoy.toISOString().split('T')[0];

      return fechaSelec !== hoyFormateado;
    },


    confirmarPago() {
      if (!this.membresiaSeleccionada) return;

      if (this.esFechaDiferente()) {
        this.mostrarConfirmacionFecha = true;
      } else {
        this.realizarPagoConfirmado();
      }
    },

    realizarPagoConfirmado() {
      this.cargando = true;
      this.mostrarConfirmacionFecha = false;

      const formatDateTimeMexico = () => {
        const fechaPart = this.fechaSeleccionada;
        const ahora = new Date();
        const horas = String(ahora.getHours()).padStart(2, '0');
        const minutos = String(ahora.getMinutes()).padStart(2, '0');
        const segundos = String(ahora.getSeconds()).padStart(2, '0');

        return `${fechaPart} ${horas}:${minutos}:${segundos}`;
      };

      let payload = {
        metodo: 'pagar',
        pago: {
          matricula: this.matricula,
          pago: this.membresiaSeleccionada.precio,
          idMembresia: this.membresiaSeleccionada.id,
          duracion: this.membresiaSeleccionada.duracion,
          fecha: formatDateTimeMexico(),
          idUsuario: localStorage.getItem('idUsuario')
        }
      };

      console.log('Fecha enviada:', payload.pago.fecha);

      HttpService.registrar(payload, "miembros.php")
        .then((registrado) => {
          this.cargando = false;
          if (registrado) {
            this.$emit("pagado", registrado);
          }
        })
        .catch((error) => {
          this.cargando = false;
          console.error('Error al realizar el pago:', error);
        });
    }


  }
};
</script>