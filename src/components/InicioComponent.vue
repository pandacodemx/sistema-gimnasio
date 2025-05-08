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
  </div>

</template>


<script>
import HttpService from "../Servicios/HttpService";
import Utiles from "../Servicios/Utiles";
import CartasPersonalizadas from "./Dialogos/CartasPersonalizadas.vue";
import SparklineComponent from "./Dialogos/SparklineComponent.vue";
import SelectorTema from "@/components/SelectorTema.vue";
export default {
  name: "InicioComponent",
  components: { CartasPersonalizadas, SparklineComponent, SelectorTema },

  data: () => ({
    nombreGimnasio: "",
    nombreUsuario: localStorage.getItem('nombreUsuario'),
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
  }),

  mounted() {
    this.obtenerDatos();
    this.nombreGimnasio = localStorage.getItem("nombreGimnasio")
    this.logo = localStorage.getItem("logoGimnasio")
  },

  methods: {
    obtenerDatos() {
      this.cargando = true;
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
    },

    crearCartas(visitas, pagos) {
      this.datosVisitas = [
        {
          color: "purple darken-1",
          icono: "mdi-calendar-star",
          nombre: "Total visitas",
          total: visitas.totalVisitas,
        },
        {
          color: "pink darken-1",
          icono: "mdi-calendar",
          nombre: "Visitas hoy",
          total: visitas.visitasHoy,
        },
        {
          color: "red darken-1",
          icono: "mdi-calendar-range",
          nombre: "Visitas semana",
          total: visitas.visitasSemana,
        },
        {
          color: "indigo darken-1",
          icono: "mdi-calendar-month",
          nombre: "Visitas mes",
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
          nombre: "Pagos hoy",
          total: "$" + pagos.pagosHoy,
        },
        {
          color: "green darken-1",
          icono: "mdi-calendar-range",
          nombre: "Pagos semana",
          total: "$" + pagos.pagosSemana,
        },
        {
          color: "orange darken-1",
          icono: "mdi-calendar-month",
          nombre: "Pagos mes",
          total: "$" + pagos.pagosMes,
        },
      ];
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
</style>