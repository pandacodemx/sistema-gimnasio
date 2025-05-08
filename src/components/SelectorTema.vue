<template>
    <v-card class="pa-1" elevation="10" max-width="400">
        <v-card-title>Personaliza tu tema</v-card-title>
        <v-select label="Selecciona un tema" :items="temasDisponibles" v-model="temaSeleccionado" @change="aplicarTema"
            outlined></v-select>
    </v-card>
</template>

<script>
export default {
    name: "SelectorTema",
    data() {
        return {
            temaSeleccionado: null,
            temasDisponibles: ["Azul", "Rojo", "Verde", "Naranja"],
            temas: {
                Azul: {
                    primary: "#2196F3",
                    secondary: "#00BFA5",
                    background: "#121212",
                    accent: "#82B1FF",
                },
                Rojo: {
                    primary: "#F44336",
                    secondary: "#E91E63",
                    background: "#1E1E1E",
                    accent: "#FF4081",
                },
                Verde: {
                    primary: "#4CAF50",
                    secondary: "#8BC34A",
                    background: "#0D1F0D",
                    accent: "#69F0AE",
                },
                Naranja: {
                    primary: "#d9652b",
                    secondary: "#4a2c1d",
                    background: "#1E1E1E",
                    accent: "#ed6f2f",
                },
            },
        };
    },
    mounted() {
        const temaGuardado = localStorage.getItem("tema_usuario");
        if (temaGuardado && this.temas[temaGuardado]) {
            this.temaSeleccionado = temaGuardado;
            this.aplicarTema(temaGuardado);
        }
    },
    methods: {
        aplicarTema(nombre) {
            const tema = this.temas[nombre];
            if (!tema) return;

            Object.assign(this.$vuetify.theme.themes.dark, tema);
            localStorage.setItem("tema_usuario", nombre);
        },
    },
};
</script>

<style scoped>
.v-card {
    background-color: #1e1e1e;
    color: white;
}
</style>