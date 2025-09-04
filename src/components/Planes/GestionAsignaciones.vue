<template>
    <div class="gestion-asignaciones">
        <v-progress-linear :active="cargando" :indeterminate="cargando" absolute top
            color="deep-purple accent-4"></v-progress-linear>

        <v-row class="mb-4" align="center">
            <v-col cols="6">
                <h1>📋 Gestión de Rutinas Asignadas</h1>
            </v-col>
            <v-col cols="6" class="text-right">
                <v-btn color="primary" @click="cargarAsignaciones">
                    <v-icon left>mdi-refresh</v-icon>
                    Actualizar
                </v-btn>
            </v-col>
        </v-row>

        <!-- Filtros -->
        <v-card class="mb-6">
            <v-card-title>Filtros de Búsqueda</v-card-title>
            <v-card-text>
                <v-row>
                    <v-col cols="12" md="4">
                        <v-autocomplete v-model="filtros.miembro_id" :items="miembros" item-text="text" item-value="id"
                            label="Filtrar por miembro" clearable></v-autocomplete>
                    </v-col>
                    <v-col cols="12" md="4">
                        <v-select v-model="filtros.estado" :items="estados" label="Filtrar por estado"
                            clearable></v-select>
                    </v-col>
                    <v-col cols="12" md="4">
                        <v-menu v-model="menuFecha" :close-on-content-click="false" transition="scale-transition"
                            offset-y min-width="auto">
                            <template v-slot:activator="{ on, attrs }">
                                <v-text-field v-model="filtros.fecha" label="Filtrar por fecha"
                                    prepend-icon="mdi-calendar" readonly clearable v-bind="attrs"
                                    v-on="on"></v-text-field>
                            </template>
                            <v-date-picker v-model="filtros.fecha" @input="menuFecha = false"></v-date-picker>
                        </v-menu>
                    </v-col>
                </v-row>
            </v-card-text>
        </v-card>

        <!-- Lista de asignaciones -->
        <v-card>
            <v-card-title>
                Lista de Rutinas Asignadas
                <v-spacer></v-spacer>
                <v-text-field v-model="search" append-icon="mdi-magnify" label="Buscar" single-line hide-details
                    clearable></v-text-field>
            </v-card-title>

            <v-data-table :headers="headers" :items="asignacionesFiltradas" :search="search" :loading="cargando"
                loading-text="Cargando asignaciones...">
                <!-- Estado activo/inactivo -->
                <template v-slot:[`item.activa`]="{ item }">
                    <v-chip :color="item.activa ? 'success' : 'error'" small dark>
                        {{ item.activa ? 'Activa' : 'Inactiva' }}
                    </v-chip>
                </template>

                <!-- Progreso -->
                <template v-slot:[`item.progreso`]="{ item }">
                    <v-progress-linear :value="calcularProgreso(item)" height="20" :color="getColorProgreso(item)">
                        <strong>{{ calcularProgreso(item) }}%</strong>
                    </v-progress-linear>
                </template>

                <!-- Acciones -->
                <template v-slot:[`item.acciones`]="{ item }">
                    <v-tooltip bottom>
                        <template v-slot:activator="{ on, attrs }">
                            <v-btn icon @click="verDetalles(item)" v-bind="attrs" v-on="on" color="info">
                                <v-icon>mdi-eye</v-icon>
                            </v-btn>
                        </template>
                        <span>Ver detalles</span>
                    </v-tooltip>

                    <v-tooltip bottom>
                        <template v-slot:activator="{ on, attrs }">
                            <v-btn icon @click="descargarPDF(item)" v-bind="attrs" v-on="on" color="primary">
                                <v-icon>mdi-download</v-icon>
                            </v-btn>
                        </template>
                        <span>Descargar PDF</span>
                    </v-tooltip>

                    <v-tooltip bottom>
                        <template v-slot:activator="{ on, attrs }">
                            <v-btn icon @click="toggleEstado(item)" v-bind="attrs" v-on="on"
                                :color="item.activa ? 'error' : 'success'">
                                <v-icon>{{ item.activa ? 'mdi-pause' : 'mdi-play' }}</v-icon>
                            </v-btn>
                        </template>
                        <span>{{ item.activa ? 'Pausar' : 'Reactivar' }} rutina</span>
                    </v-tooltip>
                </template>

                <template v-slot:no-data>
                    <v-alert type="info" class="ma-4">
                        No hay rutinas asignadas con los filtros seleccionados.
                    </v-alert>
                </template>
            </v-data-table>
        </v-card>

        <!-- Diálogo de detalles -->
        <v-dialog v-model="dialogoDetalles" max-width="800px">
            <v-card v-if="asignacionSeleccionada">
                <v-card-title>
                    Detalles de Asignación
                    <v-spacer></v-spacer>
                    <v-chip :color="asignacionSeleccionada.activa ? 'success' : 'error'" small dark>
                        {{ asignacionSeleccionada.activa ? 'Activa' : 'Inactiva' }}
                    </v-chip>
                </v-card-title>

                <v-card-text>
                    <v-simple-table>
                        <tbody>
                            <tr>
                                <td><strong>Miembro:</strong></td>
                                <td>{{ asignacionSeleccionada.miembro_nombre }}</td>
                            </tr>
                            <tr>
                                <td><strong>Rutina:</strong></td>
                                <td>{{ asignacionSeleccionada.rutina_nombre }}</td>
                            </tr>
                            <tr>
                                <td><strong>Instructor:</strong></td>
                                <td>{{ asignacionSeleccionada.instructor_nombre }}</td>
                            </tr>
                            <tr>

                                <td><strong>Fecha Inicio:</strong></td>
                                <td>{{ fechaFormateada(asignacionSeleccionada.fecha_inicio) }}</td>
                            </tr>
                            <tr>
                                <td><strong>Fecha Fin:</strong></td>
                                <td>{{ fechaFormateada(asignacionSeleccionada.fecha_fin) }}</td>
                            </tr>
                            <tr>
                                <td><strong>Progreso:</strong></td>
                                <td>
                                    <v-progress-linear :value="calcularProgreso(asignacionSeleccionada)" height="20"
                                        :color="getColorProgreso(asignacionSeleccionada)" class="mt-1">
                                        <strong>{{ calcularProgreso(asignacionSeleccionada) }}%</strong>
                                    </v-progress-linear>
                                </td>
                            </tr>
                            <tr v-if="asignacionSeleccionada.notas">
                                <td><strong>Notas:</strong></td>
                                <td>{{ asignacionSeleccionada.notas }}</td>
                            </tr>
                        </tbody>
                    </v-simple-table>
                </v-card-text>

                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="primary" @click="descargarPDF(asignacionSeleccionada)">
                        <v-icon left>mdi-download</v-icon>
                        Descargar PDF
                    </v-btn>
                    <v-btn color="blue darken-1" text @click="dialogoDetalles = false">Cerrar</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <v-snackbar v-model="mostrarMensaje" :timeout="3000" :color="mensaje.color" top>
            {{ mensaje.texto }}
        </v-snackbar>
    </div>
</template>

<script>
import HttpService from '../../Servicios/HttpService'
import jsPDF from "jspdf";
import 'jspdf-autotable';
import { formatearFechaHora } from '@/utils/fechas';

export default {
    name: "GestionAsignaciones",
    data: () => ({
        cargando: false,
        search: '',
        menuFecha: false,
        dialogoDetalles: false,
        asignaciones: [],
        asignacionSeleccionada: null,
        miembros: [],
        mostrarMensaje: false,
        mensaje: { texto: '', color: '' },
        filtros: {
            miembro_id: null,
            estado: null,
            fecha: null
        },
        estados: [
            { text: 'Activas', value: 'activa' },
            { text: 'Inactivas', value: 'inactiva' }
        ],
        headers: [
            { text: 'Miembro', value: 'miembro_nombre' },
            { text: 'Rutina', value: 'rutina_nombre' },
            { text: 'Instructor', value: 'instructor_nombre' },
            { text: 'Fecha Inicio', value: 'fecha_inicio', formatter: (value) => this.fechaFormateada(value) },
            { text: 'Fecha Fin', value: 'fecha_fin', formatter: (value) => this.fechaFormateada(value) },
            { text: 'Estado', value: 'activa' },
            { text: 'Progreso', value: 'progreso', sortable: false },
            { text: 'Acciones', value: 'acciones', sortable: false, width: '180px' }
        ]
    }),

    computed: {
        asignacionesFiltradas() {
            let filtered = this.asignaciones;

            // Filtrar por miembro
            if (this.filtros.miembro_id) {
                filtered = filtered.filter(a => a.miembro_id == this.filtros.miembro_id);
            }

            // Filtrar por estado
            if (this.filtros.estado) {
                filtered = filtered.filter(a =>
                    this.filtros.estado === 'activa' ? a.activa : !a.activa
                );
            }

            // Filtrar por fecha
            if (this.filtros.fecha) {
                filtered = filtered.filter(a => a.fecha_inicio === this.filtros.fecha);
            }

            return filtered;
        }
    },

    mounted() {
        this.cargarAsignaciones();
        this.cargarMiembros();
    },

    methods: {
        fechaFormateada(fecha) {
            return formatearFechaHora(fecha);
        },
        async cargarAsignaciones() {
            this.cargando = true;
            try {
                const respuesta = await HttpService.obtenerConDatos(
                    { metodo: "get_activas" },
                    "miembro_rutina.php"
                );
                this.asignaciones = respuesta;
            } catch (error) {
                this.mostrarError('Error cargando asignaciones');
            }
            this.cargando = false;
        },

        async cargarMiembros() {
            try {
                const respuesta = await HttpService.obtenerConDatos(
                    { metodo: "obtener_miembros_disponibles" },
                    "miembros.php"
                );
                this.miembros = respuesta.map(m => ({
                    id: m.id,
                    text: `${m.nombre} ${m.apellido} - ${m.matricula}`
                }));
            } catch (error) {
                console.error("Error cargando miembros:", error);
            }
        },

        verDetalles(asignacion) {
            this.asignacionSeleccionada = asignacion;
            this.dialogoDetalles = true;
        },

        async descargarPDF(asignacion) {
            try {
                const rutina = await HttpService.obtenerConDatos(
                    { metodo: "get_by_id", id: asignacion.rutina_id },
                    "rutinas.php"
                );

                let nombreMiembro = asignacion.miembro_nombre;
                if (!nombreMiembro) {
                    const miembro = await HttpService.obtenerConDatos(
                        { metodo: "obtener_id", id: asignacion.miembro_id },
                        "miembros.php"
                    );
                    nombreMiembro = `${miembro.nombre} ${miembro.apellido}`;
                }

                const doc = new jsPDF();

                // Configuración inicial
                const pageWidth = doc.internal.pageSize.getWidth();
                const margin = 20;
                const contentWidth = pageWidth - (margin * 2);

                // --- ENCABEZADO ---
                doc.setFillColor(41, 128, 185);
                doc.rect(0, 0, pageWidth, 60, 'F');

                // Logo/título del gimnasio
                doc.setFontSize(24);
                doc.setTextColor(255, 255, 255);
                doc.setFont(undefined, 'bold');
                doc.text("GYM FITNESS PRO", pageWidth / 2, 25, { align: 'center' });

                doc.setFontSize(16);
                doc.text("RUTINA DE ENTRENAMIENTO", pageWidth / 2, 40, { align: 'center' });

                // --- INFORMACIÓN PRINCIPAL ---
                doc.setFontSize(12);
                doc.setTextColor(0, 0, 0);
                doc.setFont(undefined, 'normal');

                let y = 80;

                // Cuadro de información
                doc.setDrawColor(200, 200, 200);
                doc.setFillColor(245, 245, 245);
                doc.roundedRect(margin, y, contentWidth, 50, 3, 3, 'F');
                doc.roundedRect(margin, y, contentWidth, 50, 3, 3, 'S');

                doc.setFont(undefined, 'bold');
                doc.text("INFORMACIÓN DE LA RUTINA", margin + 10, y + 10);
                doc.setFont(undefined, 'normal');

                // Columnas para la información
                const col1 = margin + 10;
                const col2 = pageWidth / 2;

                doc.text(`Miembro: ${nombreMiembro}`, col1, y + 20);
                doc.text(`Rutina: ${rutina.nombre}`, col1, y + 30);
                doc.text(`Objetivo: ${this.formatObjetivo(rutina.objetivo)}`, col1, y + 40);

                doc.text(`Inicio: ${this.formatFechaPDF(asignacion.fecha_inicio)}`, col2, y + 20);
                doc.text(`Fin: ${this.formatFechaPDF(asignacion.fecha_fin)}`, col2, y + 30);
                doc.text(`Duración: ${rutina.duracion_semanas} semanas`, col2, y + 40);

                y += 60;

                // --- DÍAS DE ENTRENAMIENTO ---
                doc.setFont(undefined, 'bold');
                doc.setFontSize(16);
                doc.setTextColor(41, 128, 185);
                doc.text("PLAN DE ENTRENAMIENTO", margin, y);
                y += 10;

                rutina.dias.forEach((dia, diaIndex) => {
                    // Verificar si necesita nueva página
                    if (y > 240) {
                        doc.addPage();
                        y = 20;

                        // Encabezado de página adicional
                        doc.setFontSize(10);
                        doc.setTextColor(100, 100, 100);
                        doc.text(`Rutina: ${rutina.nombre} - Página ${doc.internal.getNumberOfPages()}`, margin, 10);
                        doc.text(`Miembro: ${nombreMiembro}`, pageWidth - margin, 10, { align: 'right' });
                        doc.setTextColor(0, 0, 0);
                        y = 30;
                    }

                    // Encabezado del día
                    doc.setFillColor(52, 152, 219);
                    doc.setDrawColor(41, 128, 185);
                    doc.roundedRect(margin, y, contentWidth, 15, 3, 3, 'F');

                    doc.setFontSize(14);
                    doc.setTextColor(255, 255, 255);
                    doc.setFont(undefined, 'bold');
                    doc.text(`DÍA ${diaIndex + 1}: ${dia.nombre_dia.toUpperCase()}`, margin + 10, y + 10);
                    y += 20;

                    // Ejercicios
                    doc.setFontSize(12);
                    doc.setTextColor(0, 0, 0);
                    doc.setFont(undefined, 'normal');

                    dia.ejercicios.forEach((ejercicio, ejIndex) => {
                        if (y > 250) {
                            doc.addPage();
                            y = 20;

                            // Encabezado de página adicional
                            doc.setFontSize(10);
                            doc.setTextColor(100, 100, 100);
                            doc.text(`Rutina: ${rutina.nombre} - Página ${doc.internal.getNumberOfPages()}`, margin, 10);
                            doc.text(`Miembro: ${nombreMiembro}`, pageWidth - margin, 10, { align: 'right' });
                            doc.setTextColor(0, 0, 0);
                            y = 30;
                        }

                        // Fondo alternado para ejercicios
                        if (ejIndex % 2 === 0) {
                            doc.setFillColor(245, 245, 245);
                            doc.rect(margin, y, contentWidth, 35, 'F');
                        }

                        // Nombre del ejercicio
                        doc.setFont(undefined, 'bold');
                        doc.text(`${ejIndex + 1}. ${ejercicio.ejercicio_nombre}`, margin + 5, y + 8);

                        // Detalles del ejercicio
                        doc.setFont(undefined, 'normal');
                        doc.setFontSize(11);

                        const detailY = y + 16;
                        const detailCol1 = margin + 15;
                        const detailCol2 = detailCol1 + 50;
                        const detailCol3 = detailCol2 + 45;

                        doc.text(`Series: ${ejercicio.series}`, detailCol1, detailY);
                        doc.text(`Reps: ${ejercicio.repeticiones}`, detailCol2, detailY);
                        doc.text(`Descanso: ${ejercicio.descanso_segundos}s`, detailCol3, detailY);

                        if (ejercicio.peso_recomendado) {
                            doc.text(`Peso: ${ejercicio.peso_recomendado}`, detailCol3 + 50, detailY);
                        }

                        y += 25;

                        // Línea separadora entre ejercicios
                        if (ejIndex < dia.ejercicios.length - 1) {
                            doc.setDrawColor(200, 200, 200);
                            doc.line(margin + 10, y - 2, margin + contentWidth - 10, y - 2);
                            y += 5;
                        }
                    });

                    y += 15;
                });

                // --- NOTAS ADICIONALES ---
                if (asignacion.notas && y < 250) {
                    if (y > 220) {
                        doc.addPage();
                        y = 20;
                    }

                    doc.setFontSize(14);
                    doc.setTextColor(41, 128, 185);
                    doc.setFont(undefined, 'bold');
                    doc.text("NOTAS DEL ENTRENADOR", margin, y);
                    y += 10;

                    doc.setFontSize(12);
                    doc.setTextColor(0, 0, 0);
                    doc.setFont(undefined, 'normal');

                    // Dividir notas en líneas si son muy largas
                    const splitNotes = doc.splitTextToSize(asignacion.notas, contentWidth - 10);
                    doc.text(splitNotes, margin + 5, y + 5);
                    y += (splitNotes.length * 7) + 10;
                }

                // --- PIE DE PÁGINA ---
                const totalPages = doc.internal.getNumberOfPages();
                for (let i = 1; i <= totalPages; i++) {
                    doc.setPage(i);

                    doc.setFontSize(10);
                    doc.setTextColor(100, 100, 100);
                    doc.text(`Página ${i} de ${totalPages}`, pageWidth / 2, 285, { align: 'center' });

                    doc.text(`Asignada por: ${asignacion.instructor_nombre}`, margin, 285);
                    doc.text(`Fecha: ${this.formatFechaPDF(asignacion.created_at)}`, pageWidth - margin, 285, { align: 'right' });
                }

                // Generar y descargar PDF
                const fileName = `Rutina_${nombreMiembro.replace(/\s+/g, '_')}_${rutina.nombre.replace(/\s+/g, '_')}.pdf`;

                // Para navegadores modernos
                if (navigator.msSaveBlob) {
                    // Para IE
                    const blob = doc.output('blob');
                    navigator.msSaveBlob(blob, fileName);
                } else {
                    // Para otros navegadores
                    doc.save(fileName);
                }

            } catch (error) {
                console.error("Error generando PDF:", error);
                this.mostrarError('Error generando PDF: ' + error.message);
            }
        },

        async toggleEstado(asignacion) {
            try {
                const payload = {
                    metodo: asignacion.activa ? "desactivar" : "activar",
                    id: asignacion.id
                };

                const resultado = await HttpService.registrar(payload, "miembro_rutina.php");

                if (resultado.success) {
                    this.mostrarMensaje = true;
                    this.mensaje = {
                        texto: `Rutina ${asignacion.activa ? 'pausada' : 'reactivada'} correctamente`,
                        color: 'success'
                    };
                    this.cargarAsignaciones();
                }
            } catch (error) {
                this.mostrarError('Error cambiando estado');
            }
        },

        calcularProgreso(asignacion) {
            const inicio = new Date(asignacion.fecha_inicio);
            const fin = new Date(asignacion.fecha_fin);
            const hoy = new Date();

            const totalDias = (fin - inicio) / (1000 * 60 * 60 * 24);
            const diasTranscurridos = (hoy - inicio) / (1000 * 60 * 60 * 24);

            return Math.min(100, Math.max(0, Math.round((diasTranscurridos / totalDias) * 100)));
        },

        getColorProgreso(asignacion) {
            const progreso = this.calcularProgreso(asignacion);
            if (progreso < 30) return 'red';
            if (progreso < 70) return 'orange';
            return 'green';
        },

        formatFechaPDF(fecha) {
            if (!fecha) return 'N/A';
            const options = { year: 'numeric', month: 'long', day: 'numeric' };
            return new Date(fecha).toLocaleDateString('es-ES', options);
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
        },

        mostrarError(mensaje) {
            this.mostrarMensaje = true;
            this.mensaje = {
                texto: mensaje,
                color: 'error'
            };
        }
    }
}
</script>

<style scoped>
.gestion-asignaciones {
    padding: 20px;
}
</style>