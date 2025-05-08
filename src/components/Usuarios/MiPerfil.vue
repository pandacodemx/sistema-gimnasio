<template>
    <div class="miembros">
        <div class="d-flex flex-row justify-space-between align-center mt-6 pa-6">

            <h1>Bienvenido! {{ nombreUsuario }}</h1>
            <v-btn depressed rounded="lg" elevation="4" color="primary" @click="cambiarPassword">
                Cambiar contraseña
            </v-btn>

        </div>
        <div class="mt-8">
            <h2 class="pa-6">Pagos:</h2>
            <cartas-personalizadas :cartas="datosPagos" />
            <h2 class="pa-6">Visitas:</h2>
            <cartas-personalizadas :cartas="datosVisitas" />

        </div>
    </div>
</template>

<!---SCRIPT----------->
<script>
import HttpService from '../../Servicios/HttpService'
import CartasPersonalizadas from '../Dialogos/CartasPersonalizadas.vue'
import SelectorTema from "@/components/SelectorTema.vue";

export default {
    name: "MiPerfil",
    components: { CartasPersonalizadas, SelectorTema, },

    data: () => ({
        nombreUsuario: localStorage.getItem('nombreUsuario'),
        datosVisitas: [],
        datosPagos: [],
    }),

    mounted() {
        this.obtenerInformacion()
    },

    methods: {
        cambiarPassword() {
            this.$router.push({ name: 'CambiarPassword' })
        },

        obtenerInformacion() {
            HttpService.obtenerConDatos({
                metodo: 'informacion_perfil',
                idUsuario: localStorage.getItem('idUsuario')
            }, 'usuarios.php')
                .then(resultado => {
                    this.crearCartas(resultado.datosVisitas, resultado.datosPagos)
                })
        },

        crearCartas(visitas, pagos) {
            this.datosVisitas = [
                { color: 'purple darken-1', icono: 'mdi-calendar-star', nombre: 'Total visitas', total: visitas.totalVisitas },
                { color: 'pink darken-1', icono: 'mdi-calendar', nombre: 'Visitas hoy', total: visitas.visitasHoy },
                { color: 'red darken-1', icono: 'mdi-calendar-range', nombre: 'Visitas semana', total: visitas.visitasSemana },
                { color: 'indigo darken-1', icono: 'mdi-calendar-month', nombre: 'Visitas mes', total: visitas.visitasMes },
            ]
            this.datosPagos = [
                { color: 'blue darken-1', icono: 'mdi-currency-usd', nombre: 'Total pagos', total: '$' + pagos.totalPagos },
                { color: 'teal darken-1', icono: 'mdi-calendar', nombre: 'Pagos hoy', total: '$' + pagos.pagosHoy },
                { color: 'green darken-1', icono: 'mdi-calendar-range', nombre: 'Pagos semana', total: '$' + pagos.pagosSemana },
                { color: 'orange darken-1', icono: 'mdi-calendar-month', nombre: 'Pagos mes', total: '$' + pagos.pagosMes },
            ]
        }
    }
}
</script>

////////////ESTILOS////////////////
<style>
.miembros {
    padding: 30px;
    background-color: #1e1e1e;
    border-radius: 12px;
    min-height: 100vh;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
}
</style>