<template>
    <div class="miembros">       
        <periodo-busqueda @buscar="onBuscar"/>
        
        <cartas-totales v-if="pagos.length > 0" :totales="totalesMembresias" :titulo="'Pagos realizados membresías'" :icono="'mdi-cash-multiple'" :color="'secondary'" />
        <br>
        <hr>
        
        <v-card class="mt-3">
            <h1>Pagos totales: <span class="primary--text font-weight-bold display-1"> ${{ totalPagos }}</span></h1>
            <v-card-title>
                Pagos realizados: 
                <b v-if="!filtros.fechaInicio"> hoy</b>
                <b v-if="filtros.fechaInicio"> &nbsp; {{ filtros.fechaInicio }} - {{ filtros.fechaFin}}</b>
                <v-spacer></v-spacer>
                <v-text-field
                    v-model="busqueda"
                    append-icon="mdi-magnify"
                    label="Buscar"
                    single-line
                    hide-details
                ></v-text-field>
            </v-card-title>            

            <v-data-table
            :loading="cargando"
            :headers="encabezadoTabla"
            :items="pagos"
            :search="busqueda"
            sort-by="nombre"
            class="elevation-1"
            :footer-props="{itemsPerPageText: 'Por página'}"
            >
                <template v-slot:[`item.imagen`]="{ item }">
                    <v-avatar v-if="item.imagen">
                    <img
                        :src="urlImagen(item.imagen)"
                        alt="Foto"
                    >
                    </v-avatar>
                </template>
                

                <template slot="no-data">
                    <v-alert :value="true" color="error" icon="warning">
                        No se han encontrado datos :(
                    </v-alert>
                </template>

                <template v-slot:[`item.membresia`]="{ item }">
                    <div
                        class="medalla"
                        :class="claseMembresia(item.membresia)"
                    >
                        <v-icon left small>{{ iconoMembresia(item.membresia) }}</v-icon>
                        {{ item.membresia }}
                    </div>
                </template>
            </v-data-table>
            
        </v-card>
        <cartas-totales v-if="pagos.length > 0" class="mt-3" :totales="totalesUsuarios" :titulo="'Pagos realizados por usuario'" :icono="'mdi-account-cash'" :color="'green darken-3'" />

        <cartas-totales-miembros v-if="pagos.length > 0" class="mt-3" :totales="totalesMiembros" :titulo="'Pagos realizados por miembros'"  />

        <v-overlay :value="cargando">
            <v-progress-circular
                indeterminate
                size="64"
            ></v-progress-circular>
        </v-overlay>
        
    </div>
    
</template>
<script>
import HttpService from '../../Servicios/HttpService'
import Utiles from '../../Servicios/Utiles'
import PeriodoBusqueda from '../Dialogos/PeriodoBusqueda.vue'
import CartasTotales from '../Dialogos/CartasTotales.vue'
import CartasTotalesMiembros from '../Dialogos/CartasTotalesMiembros.vue'

export default {
    name: "Pagos",
    components: { PeriodoBusqueda, CartasTotales, CartasTotalesMiembros },
    data:()=>({
        busqueda: "",
        cargando: false,
        pagos: [],
        encabezadoTabla: [
            {text: "Fotografia", sortable: true, value: "imagen"},
            {text: "Miembro", sortable: true, value: "nombre"},
            {text: "Matrícula", sortable: true, value: "matricula"},                
            {text: "Membresía", sortable: true, value: "membresia"},
            {text: "Fecha", sortable: true, value: "fecha"},       
            {text: "Monto pagado", sortable: true, value: "monto"},
            {text: "Cobró", sortable: true, value: "usuario"},
            ],
        filtros: {
            fechaInicio: null,
            fechaFin: null
        },
        totalPagos: 0,
        totalesMembresias: [],
        totalesUsuarios: [],
        totalesMiembros: []
    }),

    mounted(){
        this.obtenerPagos()
    },

    methods: {
        onBuscar(fechas){
            console.log(fechas)
            this.filtros = {
                fechaInicio: fechas[0],
                fechaFin: fechas[1]
            }

            this.obtenerPagos()
        },

        urlImagen(imagen){
            return Utiles.generarURL(imagen)
        },

        obtenerPagos(){
            this.cargando = true
            let payload = { 
                metodo: 'obtener',
                filtros: this.filtros
            }
            HttpService.obtenerConDatos(payload, 'pagos.php')
            .then(respuesta => {
                this.pagos = respuesta.pagos
                this.totalPagos = respuesta.totalPagos
                this.totalesMembresias = respuesta.totalesMembresias
                this.totalesUsuarios = respuesta.totalesUsuario
                this.totalesMiembros = respuesta.totalesMiembros
                console.log(respuesta)
                this.cargando = false
            })

        }, 
        claseMembresia(nombre) {
        const tipo = nombre.toLowerCase()
        if (tipo.includes('oro')) return 'medalla-oro'
        if (tipo.includes('plata')) return 'medalla-plata'
        if (tipo.includes('bronce')) return 'medalla-bronce'
        if (tipo.includes('premium')) return 'medalla-premium'
        return 'medalla-default'
        },

        iconoMembresia(nombre) {
        const tipo = nombre.toLowerCase()
        if (tipo.includes('oro')) return 'mdi-trophy'
        if (tipo.includes('plata')) return 'mdi-medal'
        if (tipo.includes('bronce')) return 'mdi-star-outline'
        if (tipo.includes('premium')) return 'mdi-diamond'
        return 'mdi-certificate'
        }
    }
}
</script>
<style>
.miembros {  
  font-weight: 400;  
  padding: 30px;
  background-color: #1e1e1e;
  border-radius: 12px;
  min-height: 100vh;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);

}
.medalla {
  display: inline-flex;
  align-items: center;
  padding: 6px 12px;
  border-radius: 999px;
  font-weight: bold;
  font-size: 14px;
  color: #fff;
  text-transform: capitalize;
  box-shadow: 0 2px 6px rgba(0,0,0,0.3);
}

.medalla-oro {
  background: linear-gradient(145deg, #ff9100, #ff9c07);
}

.medalla-plata {
  background: linear-gradient(145deg, #C0C0C0, #B0B0B0);
}

.medalla-bronce {
  background: linear-gradient(145deg, #CD7F32, #B87333);
}

.medalla-premium {
  background: linear-gradient(145deg, #9C27B0, #7B1FA2);
}

.medalla-default {
  background: linear-gradient(145deg, #546E7A, #455A64);
}


</style>