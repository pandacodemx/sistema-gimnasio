<template>
    <v-card>
        <v-card-title>
            <span class="headline">{{ titulo }} Ejercicio</span>
        </v-card-title>
        <v-card-text>
            <v-container>
                <v-row>
                    <v-col cols="12" sm="6">
                        <v-text-field label="Nombre*" v-model="ejercicioLocal.nombre" required
                            :error-messages="errores.nombre"></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6">
                        <v-select v-model="ejercicioLocal.categoria_id" :items="categorias" item-text="nombre"
                            item-value="id" label="Categoría*" required
                            :error-messages="errores.categoria_id"></v-select>
                    </v-col>
                    <v-col cols="12">
                        <v-textarea label="Descripción" v-model="ejercicioLocal.descripcion" rows="2"></v-textarea>
                    </v-col>
                    <v-col cols="12">
                        <v-textarea label="Instrucciones" v-model="ejercicioLocal.instrucciones" rows="3"></v-textarea>
                    </v-col>
                    <v-col cols="12" sm="6">
                        <v-text-field label="URL de la imagen" v-model="ejercicioLocal.imagen_url"></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="6">
                        <v-text-field label="URL del video" v-model="ejercicioLocal.video_url"></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="4">
                        <v-text-field label="MET (Energia consumida)" v-model="ejercicioLocal.met"
                            type="number"></v-text-field>
                    </v-col>
                    <v-col cols="12" sm="4">
                        <v-select v-model="ejercicioLocal.nivel_dificultad" :items="nivelesDificultad"
                            label="Nivel de dificultad"></v-select>
                    </v-col>
                    <v-col cols="12" sm="4">
                        <v-select v-model="ejercicioLocal.equipamiento" :items="tiposEquipamiento"
                            label="Equipamiento necesario"></v-select>
                    </v-col>
                </v-row>
            </v-container>
            <small>* indica campo obligatorio</small>
        </v-card-text>
        <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="blue darken-1" text @click="cerrar">Cancelar</v-btn>
            <v-btn color="blue darken-1" text @click="guardar" :disabled="!esValido">Guardar</v-btn>
        </v-card-actions>
    </v-card>
</template>

<script>
export default {
    name: "FormEjercicio",
    props: {
        ejercicio: {
            type: Object,
            default: () => ({})
        },
        titulo: {
            type: String,
            default: "Agregar"
        },
        categorias: {
            type: Array,
            default: () => ([])
        }
    },
    data() {
        return {
            ejercicioLocal: { ...this.ejercicio },
            errores: {
                nombre: "",
                categoria_id: ""
            },
            nivelesDificultad: ['principiante', 'intermedio', 'avanzado'],
            tiposEquipamiento: ['peso corporal', 'mancuernas', 'barra', 'kettlebell', 'bandas elásticas', 'máquina', 'balón medicinal', 'steps']
        };
    },
    computed: {
        esValido() {
            return this.ejercicioLocal.nombre &&
                this.ejercicioLocal.nombre.trim() !== "" &&
                this.ejercicioLocal.categoria_id;
        }
    },
    watch: {
        ejercicio: {
            handler(nuevoValor) {
                this.ejercicioLocal = { ...nuevoValor };
            },
            deep: true
        },
        'ejercicioLocal.nombre': function (valor) {
            this.validarNombre(valor);
        },
        'ejercicioLocal.categoria_id': function (valor) {
            this.validarCategoria(valor);
        }
    },
    methods: {
        validarNombre(nombre) {
            if (!nombre || nombre.trim() === "") {
                this.errores.nombre = "El nombre es obligatorio";
            } else {
                this.errores.nombre = "";
            }
        },
        validarCategoria(categoriaId) {
            if (!categoriaId) {
                this.errores.categoria_id = "La categoría es obligatoria";
            } else {
                this.errores.categoria_id = "";
            }
        },
        cerrar() {
            this.$emit('cerrado', false);
        },
        guardar() {
            if (this.esValido) {
                this.$emit('registrar', { ...this.ejercicioLocal });
            }
        }
    }
};
</script>