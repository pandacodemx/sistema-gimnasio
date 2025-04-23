<template>
    <div class="miembros">        
        <periodo-busqueda @buscar="onBuscar"/>
        <cartas-totales v-if="visitas.length > 0" :totales="totalesMembresias" :titulo="'Visitas registradas por membresía'" :icono="'mdi-alarm'" :color="'error'" />
        <br>
        <h1>Visitas total:  <span class="secondary--text display-1"> {{ visitas.length }}</span></h1>
        <v-card class="mt-3">
            <v-card-title>              
                <b v-if="filtros.fechaInicio"> {{ filtros.fechaInicio }} al {{ filtros.fechaFin}}</b>
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
            :items="visitas"
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

        <hr>
        <br>
        <cartas-totales v-if="visitas.length > 0" :totales="totalesUsuarios" :titulo="'Visitas registradas (Usuarios)'" :icono="'mdi-account-check'" :color="'brown darken-4'" />
            
        <cartas-totales-miembros v-if="visitas.length > 0" class="mt-3" :totales="totalesMiembros" :titulo="'Miembros mayores visitas'"  />

    </div>
</template>
<script>
import HttpService from '../../Servicios/HttpService'
import Utiles from '../../Servicios/Utiles'
import PeriodoBusqueda from  '../Dialogos/PeriodoBusqueda.vue'
import CartasTotales from  '../Dialogos/CartasTotales.vue'
import CartasTotalesMiembros from  '../Dialogos/CartasTotalesMiembros.vue'

export default {
    name: "Visitas",
    components: { PeriodoBusqueda, CartasTotales, CartasTotalesMiembros },

    data:()=>({
        busqueda: "",
        cargando: false,
        visitas: [],
        encabezadoTabla: [
            {text: "Imagen", sortable: true, value: "imagen"},
            {text: "Miembro", sortable: true, value: "nombre"},
            {text: "Matrícula", sortable: true, value: "matricula"},
            {text: "Fecha", sortable: true, value: "fecha"},
            {text: "Membresía ", sortable: true, value: "membresia"},
            {text: "Usuario", sortable: true, value: "usuario"},
            ],
        filtros: {
            fechaInicio: null,
            fechaFin: null
        },
        totalesMembresias: [],
        totalesUsuarios: [],
        totalesMiembros: []
    }),

    mounted(){
        this.obtenerVisitas()
    },

    methods: {
        onBuscar(fechas){
            console.log(fechas)
            this.filtros = {
                fechaInicio: fechas[0],
                fechaFin: fechas[1]
            }

            this.obtenerVisitas()
        },

        urlImagen(imagen){
            return Utiles.generarURL(imagen)
        },

        obtenerVisitas(){
            this.cargando = true
            let payload = { 
                metodo: 'obtener',
                filtros: this.filtros
            }
            HttpService.obtenerConDatos(payload, 'visitas.php')
            .then(respuesta => {
                this.visitas = respuesta.visitas
                this.totalesMembresias = respuesta.totalesMembresias
                this.totalesUsuarios = respuesta.totalesUsuarios
                this.totalesMiembros = respuesta.totalesMiembros
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
</style>