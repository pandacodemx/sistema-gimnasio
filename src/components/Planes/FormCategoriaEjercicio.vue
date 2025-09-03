<template>
    <v-card>
        <v-card-title>
            <span class="headline">{{ titulo }} Categoría</span>
        </v-card-title>
        <v-card-text>
            <v-container>
                <v-row>
                    <v-col cols="12">
                        <v-text-field label="Nombre*" v-model="categoriaLocal.nombre" required
                            :error-messages="errores.nombre"></v-text-field>
                    </v-col>
                    <v-col cols="12">
                        <v-textarea label="Descripción" v-model="categoriaLocal.descripcion" rows="2"></v-textarea>
                    </v-col>
                    <v-col cols="12">
                        <v-combobox v-model="categoriaLocal.icono" :items="opcionesIconos" label="Icono"
                            append-icon="mdi-emoticon"
                            hint="Selecciona o escribe el nombre de un icono de Material Design" persistent-hint>
                            <template v-slot:selection="data">
                                <v-icon>{{ data.item }}</v-icon>
                                <span class="ml-2">{{ data.item }}</span>
                            </template>
                            <template v-slot:item="data">
                                <v-icon>{{ data.item }}</v-icon>
                                <span class="ml-2">{{ data.item }}</span>
                            </template>
                        </v-combobox>
                        <div class="mt-2">
                            <v-icon v-if="categoriaLocal.icono">{{ categoriaLocal.icono }}</v-icon>
                            <span v-if="categoriaLocal.icono" class="ml-2">{{ categoriaLocal.icono }}</span>
                            <span v-else class="caption grey--text">Previsualización del icono</span>
                        </div>
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
    name: "FormCategoriaEjercicio",
    props: {
        categoria: {
            type: Object,
            default: () => ({})
        },
        titulo: {
            type: String,
            default: "Agregar"
        }
    },
    data() {
        return {
            categoriaLocal: { ...this.categoria },
            errores: {
                nombre: ""
            },
            opcionesIconos: [
                'mdi-dumbbell', 'mdi-run', 'mdi-run-fast', 'mdi-yoga', 'mdi-arm-flex',
                'mdi-weight-lifter', 'mdi-bike', 'mdi-swim', 'mdi-walk', 'mdi-handball',
                'mdi-karate', 'mdi-soccer', 'mdi-basketball', 'mdi-baseball', 'mdi-volleyball',
                'mdi-tennis', 'mdi-golf', 'mdi-ski', 'mdi-snowboard', 'mdi-skateboarding',
                'mdi-surfing', 'mdi-hiking', 'mdi-kayaking', 'mdi-heart', 'mdi-star', 'mdi-shape'
            ]
        };
    },
    computed: {
        esValido() {
            return this.categoriaLocal.nombre && this.categoriaLocal.nombre.trim() !== "";
        }
    },
    watch: {
        categoria: {
            handler(nuevoValor) {
                this.categoriaLocal = { ...nuevoValor };
            },
            deep: true
        },
        'categoriaLocal.nombre': function (valor) {
            this.validarNombre(valor);
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
        cerrar() {
            this.$emit('cerrado', false);
        },
        guardar() {
            if (this.esValido) {
                this.$emit('registrar', { ...this.categoriaLocal });
            }
        }
    }
};
</script>