<template>
  <div>
    <div class="bienvenida d-flex flex-row">
      <div class="d-flex flex-row"><v-list-item-avatar size="100" mr-8>
          <img :src="urlImagen(logo)" alt="Logo">
        </v-list-item-avatar>
        <div class="d-flex flex-column">
          <h1 class="primary--text">Bienvenido! </h1> {{ nombreUsuario }}
          <small>Dashboard {{ nombreGimnasio }} </small>
        </div>
      </div>
    </div>


    <cartas-personalizadas :cartas="datosVisitas" />
    <div class="row">
      <div class="col-sm-6 col-lg-4 col-12">
        <sparkline-component :etiquetas="etiquetasVisitasHora" :valores="valoresVisitasHora" :color="'pink darken-1'"
          :titulo="'Visitas por hora'" :subtitulo="'Visitas registras por hora'" />
      </div>
      <div class="col-sm-6 col-lg-4 col-12">
        <sparkline-component :etiquetas="etiquetasVisitasSemana" :valores="valoresVisitasSemana" :color="'red darken-1'"
          :titulo="'Visitas semana'" :subtitulo="'Visitas registras en esta semana'" />
      </div>
      <div class="col-sm-6 col-lg-4 col-12">
        <sparkline-component :etiquetas="etiquetasVisitasMes" :valores="valoresVisitasMes" :color="'indigo darken-1'"
          :titulo="'Visitas mes'" :subtitulo="'Visitas registras por días de este mes'" />
      </div>
    </div>

    <cartas-personalizadas :cartas="datosPagos" class="mt-3" />
    <div class="row">
      <div class="col-sm-6 col-lg-4 col-12">
        <sparkline-component :etiquetas="etiquetasPagosSemana" :valores="valoresPagosSemana" :color="'green darken-1'"
          :titulo="'Pagos semana'" :subtitulo="'Pagos registrados esta semana'" />
      </div>
      <div class="col-sm-6 col-lg-4 col-12">
        <sparkline-component :etiquetas="etiquetasPagosMes" :valores="valoresPagosMes" :color="'orange darken-1'"
          :titulo="'Pagos mes'" :subtitulo="'Pagos registrados este mes'" />
      </div>
      <div class="col-sm-6 col-lg-4 col-12">
        <sparkline-component :etiquetas="etiquetasPagosMeses" :valores="valoresPagosMeses" :color="'blue darken-1'"
          :titulo="'Pagos por meses'" :subtitulo="'Pagos registrados por meses de este año'" />
      </div>
    </div>
    <v-overlay :value="cargando">
      <v-progress-circular size="64"></v-progress-circular>
    </v-overlay>
    <div class="mt-3"> <selector-tema /></div>



    <v-dialog v-model="modalMembresiasPorVencer" max-width="800px">
      <v-card>
        <v-card-title>
          <v-icon left>mdi-timer-alert</v-icon>
          Membresías por vencer
        </v-card-title>
        <v-card-text>
          <v-simple-table dense>
            <thead>
              <tr>
                <th>Matrícula</th>
                <th>Nombre</th>
                <th>Membresía</th>
                <th>Teléfono</th>
                <th>Fecha Fin</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="m in membresiasPorVencer" :key="m.matricula">
                <td>{{ m.matricula }}</td>
                <td>{{ m.nombre }}</td>
                <td>{{ m.nombre_membresia }}</td>
                <td>{{ m.telefono }}</td>
                <td>{{ fechaFormateada(m.fechaFin) }}</td>
              </tr>
            </tbody>
          </v-simple-table>
        </v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn color="primary" @click="modalMembresiasPorVencer = false">Cerrar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>

</template>


<script>
import HttpService from "../Servicios/HttpService";
import Utiles from "../Servicios/Utiles";
import CartasPersonalizadas from "./Dialogos/CartasPersonalizadas.vue";
import SparklineComponent from "./Dialogos/SparklineComponent.vue";
import SelectorTema from "@/components/SelectorTema.vue";
import { formatearFechaHora } from '@/utils/fechas';
export default {
  name: "InicioComponent",
  components: { CartasPersonalizadas, SparklineComponent, SelectorTema },

  data: () => ({
    nombreGimnasio: "",
    nombreUsuario: localStorage.getItem('usuario'),
    logo: "",
    cargando: false,
    datosVisitas: [],
    datosPagos: [],
    etiquetasVisitasHora: [],
    valoresVisitasHora: [],
    etiquetasVisitasSemana: [],
    valoresVisitasSemana: [],
    etiquetasVisitasMes: [],
    valoresVisitasMes: [],
    etiquetasPagosSemana: [],
    valoresPagosSemana: [],
    etiquetasPagosMes: [],
    valoresPagosMes: [],
    etiquetasPagosMeses: [],
    valoresPagosMeses: [],
    membresiasPorVencer: [],
    modalMembresiasPorVencer: false,
  }),

  mounted() {
    this.obtenerDatos();
    this.nombreGimnasio = localStorage.getItem("nombreGimnasio")
    this.logo = localStorage.getItem("logoGimnasio")
  },

  methods: {
    fechaFormateada(fecha) {
      return formatearFechaHora(fecha);
    },
    obtenerDatos() {
      this.cargando = true;

      HttpService.obtenerConDatos({ metodo: "membresias_por_vencer" }, "miembros.php")
        .then(resultado => {
          this.membresiasPorVencer = resultado;
          HttpService.obtenerConDatos(
            {
              metodo: "obtener",
            },
            "inicio.php"
          ).then((resultado) => {
            this.crearCartas(resultado.datosVisitas, resultado.datosPagos);
            this.etiquetasVisitasHora = Utiles.obtenerClaves(resultado.visitasHora);
            this.valoresVisitasHora = Utiles.obtenerValores(resultado.visitasHora);
            let visitasSemana = Utiles.cambiarDiaSemana(resultado.visitasSemana);
            this.etiquetasVisitasSemana = Utiles.obtenerClaves(visitasSemana);
            this.valoresVisitasSemana = Utiles.obtenerValores(visitasSemana);
            this.etiquetasVisitasMes = Utiles.obtenerClaves(resultado.visitasMes);
            this.valoresVisitasMes = Utiles.obtenerValores(resultado.visitasMes);
            let pagosSemana = Utiles.cambiarDiaSemana(resultado.pagosSemana);
            this.etiquetasPagosSemana = Utiles.obtenerClaves(pagosSemana);
            this.valoresPagosSemana = Utiles.obtenerValoresPagos(pagosSemana);
            this.etiquetasPagosMes = Utiles.obtenerClaves(resultado.pagosMes);
            this.valoresPagosMes = Utiles.obtenerValoresPagos(resultado.pagosMes);
            let pagosMeses = Utiles.cambiarNumeroANombreMes(resultado.pagosMeses);
            this.etiquetasPagosMeses = Utiles.obtenerClaves(pagosMeses);
            this.valoresPagosMeses = Utiles.obtenerValoresPagos(pagosMeses);
            this.cargando = false;
          });
        });
    },


    crearCartas(visitas, pagos) {
      this.datosVisitas = [
        /*{
          color: "purple darken-1",
          icono: "mdi-calendar-star",
          nombre: "Total visitas",
          total: visitas.totalVisitas,
        },*/
        {
          color: "pink darken-1",
          icono: "mdi-calendar",
          nombre: "Visitas Hoy",
          total: visitas.visitasHoy,
        },
        {
          color: "red darken-1",
          icono: "mdi-calendar-range",
          nombre: "Visitas Semana",
          total: visitas.visitasSemana,
        },
        {
          color: "indigo darken-1",
          icono: "mdi-calendar-month",
          nombre: "Visitas Mes",
          total: visitas.visitasMes,
        },
      ];
      this.datosPagos = [
        {
          color: "blue darken-1",
          icono: "mdi-currency-usd",
          nombre: "Total pagos",
          total: "$" + pagos.totalPagos,
        },
        {
          color: "teal darken-1",
          icono: "mdi-calendar",
          nombre: "Hoy",
          total: "$" + pagos.pagosHoy,
        },
        {
          color: "green darken-1",
          icono: "mdi-calendar-range",
          nombre: "Semana",
          total: "$" + pagos.pagosSemana,
        },
        {
          color: "orange darken-1",
          icono: "mdi-calendar-month",
          nombre: "Mes",
          total: "$" + pagos.pagosMes,
        },
      ];
      this.datosVisitas.push({
        color: "orange darken-2",
        icono: "mdi-clock-alert",
        nombre: "Membresias - A vencer",
        total: this.membresiasPorVencer.length,
        accion: () => this.modalMembresiasPorVencer = true
      });
    },


    urlImagen(imagen) {
      return Utiles.generarURL(imagen);
    },
  },
};
</script>
<style>
.bienvenida {
  display: flex;
  flex-direction: row;
  width: 100%;
  height: 150px;
  background-color: rgb(31, 30, 30);
  border-radius: 10px;
  margin-bottom: 10px;
  padding: 30px;
}


.v-card--material-stats:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.2);
}

.v-card--material-stats {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  cursor: pointer;
  opacity: 0;
  animation: fadeInUp 1.5s forwards;
  animation-delay: calc(var(--index) * 0.1s);
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }

  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>