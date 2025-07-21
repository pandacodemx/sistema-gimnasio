<template>
    <div>
        <h1>Editar usuario</h1>
        <form-usuario @registrado="onRegistrado" :usuario="usuario"></form-usuario>

        <form-cambiar-password v-if="usuario.id" :id-usuario="usuario.id" />

        <v-progress-linear :active="cargando" :indeterminate="cargando" absolute top
            color="primary accent-4"></v-progress-linear>
        <v-snackbar v-model="mostrarMensaje" :multi-line="multiLine" :timeout="3000" :color="mensaje.color" center
            shaped bottom>
            {{ mensaje.texto }}
            <template v-slot:action="{ attrs }">
                <v-btn color="blackbox" text v-bind="attrs" @click="mostrarMensaje = false">
                    Cerrar
                </v-btn>
            </template>
        </v-snackbar>
    </div>
</template>
<script>
import HttpService from '../../Servicios/HttpService'
import FormUsuario from './FormUsuario.vue'
import FormCambiarPassword from './FormCambiarPassword.vue'

export default {

    name: "EditarUsuario",
    components: { FormUsuario, FormCambiarPassword },

    data: () => ({
        cargando: false,
        usuario: {},
        mostrarMensaje: false,
        mensaje: {
            texto: "",
            color: ""
        },
    }),

    mounted() {
        this.cargando = true
        const payload = {
            metodo: "un_usuario",
            id: this.$route.params.id
        }

        HttpService.obtenerConDatos(payload, "usuarios.php")
            .then(resultado => {
                this.usuario = resultado
                this.cargando = false
            })
    },

    methods: {
        onRegistrado(usuario) {
            this.cargando = true
            this.usuario = usuario
            console.log(this.usuario)
            let payload = {
                metodo: "put",
                usuario: this.usuario
            }
            HttpService.registrar(payload, "usuarios.php")
                .then(resultado => {
                    if (resultado) {
                        this.mostrarMensaje = true
                        this.mensaje.texto = "Usuario actualizado"
                        this.mensaje.color = "success"

                        setTimeout(() =>
                            this.$router.push({
                                name: "Usuarios"
                            }),
                            3000
                        )
                        this.cargando = false
                    }
                })
        }
    }
}
</script>
