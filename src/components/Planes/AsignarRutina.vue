<template>
    <div class="asignar-rutina">
        <v-progress-linear :active="cargando" :indeterminate="cargando" absolute top
            color="deep-purple accent-4"></v-progress-linear>

        <v-row class="mb-4" align="center">
            <v-col cols="6">
                <h1>👥 Asignar Rutina a Miembro</h1>
            </v-col>
            <v-col cols="6" class="text-right">
                <v-btn color="secondary" @click="$router.go(-1)">
                    <v-icon left>mdi-arrow-left</v-icon>
                    Volver
                </v-btn>
            </v-col>
        </v-row>

        <v-card class="mb-6">
            <v-card-title>Seleccionar Miembro y Rutina</v-card-title>
            <v-card-text>
                <v-row>
                    <v-col cols="12" md="6">
                        <v-autocomplete v-model="asignacion.miembro_id" :items="miembros" item-text="text"
                            item-value="id" label="Seleccionar Miembro*"
                            :rules="[v => !!v || 'El miembro es obligatorio']" required></v-autocomplete>
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-autocomplete v-model="asignacion.rutina_id" :items="rutinas" item-text="nombre"
                            item-value="id" label="Seleccionar Rutina*"
                            :rules="[v => !!v || 'La rutina es obligatoria']" required></v-autocomplete>
                    </v-col>
                </v-row>
            </v-card-text>
        </v-card>

        <!-- Información de la rutina seleccionada -->
        <v-card v-if="rutinaSeleccionada" class="mb-6">
            <v-card-title>
                📋 {{ rutinaSeleccionada.nombre }}
                <v-chip :color="getColorDificultad(rutinaSeleccionada.nivel_dificultad)" class="ml-2" small dark>
                    {{ rutinaSeleccionada.nivel_dificultad }}
                </v-chip>
            </v-card-title>
            <v-card-text>
                <v-row>
                    <v-col cols="12" md="6">
                        <strong>Objetivo:</strong> {{ formatObjetivo(rutinaSeleccionada.objetivo) }}<br>
                        <strong>Duración:</strong> {{ rutinaSeleccionada.duracion_semanas }} semanas<br>
                        <strong>Días por semana:</strong> {{ rutinaSeleccionada.total_dias }}
                    </v-col>
                    <v-col cols="12" md="6">
                        <strong>Descripción:</strong> {{ rutinaSeleccionada.descripcion || 'Sin descripción' }}
                    </v-col>
                </v-row>

                <v-alert type="info" class="mt-3">
                    <v-icon left>mdi-information</v-icon>
                    Esta rutina contiene {{ totalEjercicios }} ejercicios distribuidos en {{
                        rutinaSeleccionada.total_dias }} días por semana.
                </v-alert>
            </v-card-text>
        </v-card>

        <!-- Configuración de la asignación -->
        <v-card class="mb-6">
            <v-card-title>Configuración de la Asignación</v-card-title>
            <v-card-text>
                <v-row>
                    <v-col cols="12" md="6">
                        <v-menu v-model="menuFechaInicio" :close-on-content-click="false" transition="scale-transition"
                            offset-y min-width="auto">
                            <template v-slot:activator="{ on, attrs }">
                                <v-text-field v-model="asignacion.fecha_inicio" label="Fecha de inicio*"
                                    prepend-icon="mdi-calendar" readonly v-bind="attrs" v-on="on"
                                    :rules="[v => !!v || 'La fecha de inicio es obligatoria']"></v-text-field>
                            </template>
                            <v-date-picker v-model="asignacion.fecha_inicio" @input="menuFechaInicio = false"
                                :min="fechaHoy"></v-date-picker>
                        </v-menu>
                    </v-col>
                    <v-col cols="12" md="6">
                        <v-text-field v-model="asignacion.duracion_semanas" label="Duración (semanas)*" type="number"
                            min="1" :rules="[v => !!v || 'La duración es obligatoria']"></v-text-field>
                    </v-col>
                    <v-col cols="12">
                        <v-textarea v-model="asignacion.notas" label="Notas para el miembro" rows="3"
                            placeholder="Instrucciones especiales, recomendaciones, etc."></v-textarea>
                    </v-col>
                </v-row>
            </v-card-text>
        </v-card>

        <!-- Opciones de entrega -->
        <v-card class="mb-6">
            <v-card-title>Opciones de Entrega</v-card-title>
            <v-card-text>
                <v-checkbox v-model="opcionesEntrega.enviarEmail" label="Enviar por correo electrónico"></v-checkbox>

                <v-checkbox v-model="opcionesEntrega.generarPDF" label="Generar PDF para descarga"></v-checkbox>

                <v-checkbox v-model="opcionesEntrega.mostrarWeb" label="Mostrar en versión web interactiva" disabled
                    :value="true"></v-checkbox>

                <div v-if="opcionesEntrega.enviarEmail" class="mt-3">
                    <v-alert type="info">
                        <v-icon left>mdi-email</v-icon>
                        Se enviará un correo con los detalles de la rutina y enlaces a los videos demostrativos.
                    </v-alert>
                </div>

                <div v-if="opcionesEntrega.generarPDF" class="mt-3">
                    <v-alert type="info">
                        <v-icon left>mdi-file-pdf</v-icon>
                        Se generará un PDF con la rutina completa, incluyendo imágenes de los ejercicios.
                    </v-alert>
                </div>
            </v-card-text>
        </v-card>

        <v-btn color="primary" @click="asignarRutina" :loading="asignando" :disabled="!formValido" large>
            <v-icon left>mdi-check</v-icon>
            Asignar Rutina
        </v-btn>

        <v-snackbar v-model="mostrarMensaje" :timeout="3000" :color="mensaje.color" top>
            {{ mensaje.texto }}
            <template v-slot:action="{ attrs }">
                <v-btn v-if="mensaje.urlPdf" color="white" text v-bind="attrs" @click="descargarPDF">
                    Descargar PDF
                </v-btn>
            </template>
        </v-snackbar>
    </div>
</template>

<script>
import HttpService from '../../Servicios/HttpService'
import jsPDF from 'jspdf'
import html2canvas from 'html2canvas'

export default {
    name: "AsignarRutina",
    data: () => ({
        cargando: false,
        asignando: false,
        menuFechaInicio: false,
        miembros: [],
        rutinas: [],
        rutinaSeleccionada: null,
        asignacion: {
            miembro_id: null,
            rutina_id: null,
            fecha_inicio: new Date().toISOString().substr(0, 10),
            duracion_semanas: 4,
            notas: '',
            asignada_por: 1
        },
        opcionesEntrega: {
            enviarEmail: true,
            generarPDF: true,
            mostrarWeb: true
        },
        mostrarMensaje: false,
        mensaje: { texto: '', color: '', urlPdf: '' },
        fechaHoy: new Date().toISOString().substr(0, 10)
    }),

    computed: {
        formValido() {
            return this.asignacion.miembro_id &&
                this.asignacion.rutina_id &&
                this.asignacion.fecha_inicio &&
                this.asignacion.duracion_semanas > 0;
        },
        totalEjercicios() {
            if (!this.rutinaSeleccionada || !this.rutinaSeleccionada.dias) return 0;
            return this.rutinaSeleccionada.dias.reduce((total, dia) => {
                const ejerciciosLength = dia.ejercicios ? dia.ejercicios.length : 0;
                return total + ejerciciosLength;
            }, 0);
        }
    },

    mounted() {
        this.cargarMiembros();
        this.cargarRutinas();
    },

    watch: {
        'asignacion.rutina_id': function (nuevoId) {
            if (nuevoId) {
                this.cargarDetallesRutina(nuevoId);
            }
        }
    },

    methods: {
        async cargarMiembros() {
            this.cargando = true;
            try {
                const respuesta = await HttpService.obtenerConDatos(
                    { metodo: "obtener_miembros_disponibles" },
                    "miembros.php"
                );
                this.miembros = respuesta.map(m => ({
                    id: m.id,
                    text: `${m.nombre} / ${m.matricula} - ${m.email}`
                }));
            } catch (error) {
                console.error("Error cargando miembros:", error);
            }
            this.cargando = false;
        },

        async cargarRutinas() {
            try {
                const respuesta = await HttpService.obtenerConDatos(
                    { metodo: "get" },
                    "rutinas.php"
                );
                this.rutinas = respuesta;
            } catch (error) {
                console.error("Error cargando rutinas:", error);
            }
        },

        async cargarDetallesRutina(id) {
            try {
                const respuesta = await HttpService.obtenerConDatos(
                    { metodo: "get_by_id", id: id },
                    "rutinas.php"
                );
                this.rutinaSeleccionada = respuesta;
            } catch (error) {
                console.error("Error cargando detalles de rutina:", error);
            }
        },

        async asignarRutina() {
            this.asignando = true;

            try {

                const payload = {
                    metodo: "asignar",
                    asignacion: {
                        ...this.asignacion,
                        fecha_fin: this.calcularFechaFin()
                    }
                };

                const resultado = await HttpService.registrar(payload, "miembro_rutina.php");

                if (resultado.success) {

                    if (this.opcionesEntrega.generarPDF) {
                        await this.generarPDF();
                    }

                    // 3. Enviar email si está seleccionado
                    if (this.opcionesEntrega.enviarEmail) {
                        await this.enviarEmail(resultado.id);
                    }

                    this.mostrarMensaje = true;
                    this.mensaje = {
                        texto: 'Rutina asignada exitosamente',
                        color: 'success',
                        urlPdf: this.mensaje.urlPdf
                    };
                    this.limpiarFormulario();
                } else {
                    throw new Error(resultado.message || 'Error desconocido');
                }
            }
            catch (error) {
                this.mostrarMensaje = true;
                this.mensaje = {
                    texto: 'Error al asignar la rutina: ' + error.message,
                    color: 'error'
                };
            }
            this.asignando = false;
        },

        calcularFechaFin() {
            const fechaInicio = new Date(this.asignacion.fecha_inicio);
            fechaInicio.setDate(fechaInicio.getDate() + (this.asignacion.duracion_semanas * 7));
            return fechaInicio.toISOString().substr(0, 10);
        },

        limpiarFormulario() {
            this.asignacion = {
                miembro_id: null,
                rutina_id: null,
                fecha_inicio: new Date().toISOString().substr(0, 10),
                duracion_semanas: 4,
                notas: '',
                asignada_por: 1
            };
            this.rutinaSeleccionada = null;
            this.opcionesEntrega = {
                enviarEmail: true,
                generarPDF: true,
                mostrarWeb: true
            };
        },

        async generarPDF() {
            try {
                const doc = new jsPDF();


                doc.setFontSize(20);
                doc.setTextColor(40, 40, 40);
                doc.text(`RUTINA DE ENTRENAMIENTO`, 105, 20, { align: 'center' });

                doc.setFontSize(16);
                doc.text(this.rutinaSeleccionada.nombre, 105, 30, { align: 'center' });


                doc.setFontSize(12);
                doc.text(`Miembro: ${this.obtenerNombreMiembro()}`, 20, 50);
                doc.text(`Fecha inicio: ${this.asignacion.fecha_inicio}`, 20, 60);
                doc.text(`Duración: ${this.asignacion.duracion_semanas} semanas`, 20, 70);
                doc.text(`Objetivo: ${this.formatObjetivo(this.rutinaSeleccionada.objetivo)}`, 20, 80);


                doc.line(20, 90, 190, 90);


                let y = 100;
                this.rutinaSeleccionada.dias.forEach((dia, index) => {

                    if (y > 250) {
                        doc.addPage();
                        y = 20;
                    }


                    doc.setFontSize(14);
                    doc.setTextColor(0, 0, 0);
                    doc.text(`DÍA ${index + 1}: ${dia.nombre_dia}`, 20, y);
                    y += 10;


                    doc.setFontSize(12);
                    dia.ejercicios.forEach((ejercicio, ejIndex) => {
                        if (y > 270) {
                            doc.addPage();
                            y = 20;
                        }

                        doc.text(`${ejIndex + 1}. ${ejercicio.ejercicio_nombre}`, 25, y);
                        doc.text(`   Series: ${ejercicio.series} | Reps: ${ejercicio.repeticiones} | Descanso: ${ejercicio.descanso_segundos}s`, 25, y + 5);

                        if (ejercicio.peso_recomendado) {
                            doc.text(`   Peso: ${ejercicio.peso_recomendado}`, 25, y + 10);
                            y += 5;
                        }

                        y += 15;
                    });

                    y += 10;
                });


                if (this.asignacion.notas) {
                    if (y > 250) {
                        doc.addPage();
                        y = 20;
                    }

                    doc.setFontSize(12);
                    doc.text(`Notas: ${this.asignacion.notas}`, 20, y);
                }


                const pdfBlob = doc.output('blob');
                const url = URL.createObjectURL(pdfBlob);
                this.mensaje.urlPdf = url;


                window.open(url, '_blank');

            } catch (error) {
                console.error("Error generando PDF:", error);
            }
        },

        async enviarEmail(asignacionId) {
            try {
                const payload = {
                    metodo: "enviar_rutina",
                    miembro_id: this.asignacion.miembro_id,
                    rutina_id: this.asignacion.rutina_id,
                    asignacion_id: asignacionId
                };

                const resultado = await HttpService.registrar(payload, "correo.php");

                if (resultado && resultado.success) {
                    console.log("Email enviado correctamente");
                } else {
                    console.warn("Error enviando email:", resultado.message);
                }
            } catch (error) {
                console.error("Error enviando email:", error);
            }
        },

        obtenerNombreMiembro() {
            const miembro = this.miembros.find(m => m.id === this.asignacion.miembro_id);
            return miembro ? miembro.text : 'Miembro';
        },

        descargarPDF() {
            const link = document.createElement('a');
            link.href = this.mensaje.urlPdf;
            link.download = `rutina-${this.rutinaSeleccionada.nombre}.pdf`;
            link.click();
        },

        getColorDificultad(nivel) {
            const colores = { principiante: 'green', intermedio: 'orange', avanzado: 'red' };
            return colores[nivel] || 'grey';
        },

        formatObjetivo(objetivo) {
            const objetivos = {
                'perdida_grasa': 'Pérdida de grasa',
                'ganancia_muscular': 'Ganancia muscular',
                'fuerza': 'Fuerza',
                'resistencia': 'Resistencia',
                'general': 'General'
            };
            return objetivos[objetivo] || objetivo;
        }
    }
}
</script>

<style scoped>
.asignar-rutina {
    padding: 20px;
}
</style>