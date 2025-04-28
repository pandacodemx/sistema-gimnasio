<template>
    <div>
        <v-progress-linear
        :active="cargando"
        :indeterminate="cargando"
        absolute
        top
        color="primary accent-4"
        ></v-progress-linear>

        <v-snackbar
        v-model="mostrarMensaje"
        :timeout="3000"
        :color="mensaje.color"
        top
        >
            {{ mensaje.texto }}
        </v-snackbar>

        <h1>Registrar usuario</h1>
        <form-usuario :usuario="usuario" @registrado="onRegistrado"/>
    </div>
</template>

<script>
import HttpService from '../../Servicios/HttpService'
import FormUsuario from './FormUsuario.vue'

export default {
    name: "NuevoUsuario",
    components: { FormUsuario },

    data:() => ({
        cargando: false,
        usuario: {
            usuario: "",
            nombre: "",
            telefono: "",
        },
        mostrarMensaje: false, 
        mensaje: {
            texto: "",
            color: ""
        },
    }),

    methods: {
        generarPasswordAleatoria(longitud = 10) {
            const caracteres = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+-=[]{}|;:,.<>?';
            let password = '';
            for (let i = 0; i < longitud; i++) {
                password += caracteres.charAt(Math.floor(Math.random() * caracteres.length));
            }
            return password;
        },

        onRegistrado(usuario){
            this.cargando = true
            this.usuario = usuario
            console.log(this.usuario)

            const passwordTemporal = this.generarPasswordAleatoria();

            let payload = {
                metodo: "registrar",
                usuario: this.usuario,
                password: passwordTemporal, 
            }

            HttpService.registrar(payload, "usuarios.php")
            .then(resultado => {
                if(resultado){
                    this.mostrarMensaje = true
                    this.mensaje.texto = `Usuario registrado. Por favor cambiar la contraseña editando el usuario.`
                    this.mensaje.color = "success"
                    this.cargando = false
                    this.usuario = {
                        usuario: "",
                        nombre: "",
                        telefono: "",
                    }
                }
            })
        }
    }
}
</script>