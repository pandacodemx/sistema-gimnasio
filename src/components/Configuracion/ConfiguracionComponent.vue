<template>
    <div class="pa-10">
        <h1 class=" mb-5 ">Configuración</h1>
        <form-configuracion :ajustes="datosAjustes" @registrar="onRegistrar" v-if="datosAjustes" />
        <v-overlay :value="cargando">
            <v-progress-circular size="64"></v-progress-circular>
        </v-overlay>
        <v-snackbar
        v-model="mostrarMensaje"
        :timeout="3000"
        :color="mensaje.color"
        top
        >
        {{ mensaje.texto }}
        </v-snackbar>
    </div>
</template>
<script>
import FormConfiguracion from './FormConfiguracion.vue'
import HttpService from '../../Servicios/HttpService'

export default {
    name: "ConfiguracionComponent",
    components: { FormConfiguracion },

    data:()=>({
        datosAjustes: null,
        cargando: false,
        mostrarMensaje: false, 
        mensaje: {
            texto: "",
            color: ""
        }
    }),

    mounted(){
        this.obtenerAjustes()
    },

    methods: {
        onRegistrar(ajustes){
            this.cargando = true
            const imagenCambia = ajustes.logo.includes('data:image')
            if(!imagenCambia){
                ajustes.logo = ajustes.logo.split('api/')[1]
            }
            ajustes.logoCambia =  imagenCambia
            console.log(ajustes)
            HttpService.registrar({
                metodo: 'registrar',
                ajustes: ajustes
            }, 'ajustes.php')
            .then(resultado =>{
                if(resultado){
                    this.mostrarMensaje = true
                    this.mensaje = {
                        texto: "Datos actualizados correctamente",
                        color: "success"
                    }
                    this.cargando = false
                    this.obtenerAjustes()
                }
            })
        },

        obtenerAjustes(){
            this.cargando = true
            HttpService.obtenerConDatos(
                { metodo: 'obtener'},
                'ajustes.php'
            )
            .then(resultado => {
                this.datosAjustes = resultado
                console.log(resultado)
                this.cargando = false
            })
        }
    }
}
</script>