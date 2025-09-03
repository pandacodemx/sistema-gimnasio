<template>
    <div class="miembros">
        <periodo-busqueda @buscar="onBuscar" />
        <cartas-totales v-if="visitas.length > 0" :totales="totalesMembresias"
            :titulo="'Visitas registradas por membresía'" :icono="'mdi-alarm'" :color="'error'" />
        <br>
        <h1>📆 Visitas total: <span class="secondary--text display-1"> {{ visitas.length }}</span></h1>
        <v-card class="mt-3">
            <v-card-title>
                <b v-if="filtros.fechaInicio"> {{ filtros.fechaInicio }} al {{ filtros.fechaFin }}</b>
                <v-spacer></v-spacer>
                <v-text-field v-model="busqueda" append-icon="mdi-magnify" label="Buscar" single-line
                    hide-details></v-text-field>
            </v-card-title>
            <v-btn color="error" @click="generarPDF">
                <v-icon left>mdi-file-pdf-box</v-icon>
                Descargar PDF
            </v-btn>
            <v-btn color="success" @click="generarExcel">
                <v-icon left>mdi-file-excel</v-icon>
                Descargar Excel
            </v-btn>

            <v-data-table :loading="cargando" :headers="encabezadoTabla" :items="visitas" :search="busqueda"
                sort-by="nombre" class="elevation-1" :footer-props="{ itemsPerPageText: 'Por página' }">
                <template v-slot:[`item.imagen`]="{ item }">
                    <v-avatar v-if="item.imagen">
                        <img :src="urlImagen(item.imagen)" alt="Foto">
                    </v-avatar>
                </template>

                <template v-slot:[`item.fecha`]="{ item }">
                    {{ fechaFormateada(item.fecha) }}
                </template>

                <template slot="no-data">
                    <v-alert :value="true" color="error" icon="warning">
                        No se han encontrado datos :(
                    </v-alert>
                </template>

                <template v-slot:[`item.membresia`]="{ item }">
                    <div class="medalla" :class="claseMembresia(item.membresia)">
                        <v-icon left small>{{ iconoMembresia(item.membresia) }}</v-icon>
                        {{ item.membresia }}
                    </div>
                </template>
            </v-data-table>
        </v-card>

        <hr>
        <br>
        <cartas-totales v-if="visitas.length > 0" :totales="totalesUsuarios" :titulo="'Visitas registradas (Usuarios)'"
            :icono="'mdi-account-check'" :color="'brown darken-4'" />

        <cartas-totales-miembros v-if="visitas.length > 0" class="mt-3" :totales="totalesMiembros"
            :titulo="'Miembros mayores visitas'" />

    </div>
</template>
<script>
import HttpService from '../../Servicios/HttpService'
import Utiles from '../../Servicios/Utiles'
import PeriodoBusqueda from '../Dialogos/PeriodoBusqueda.vue'
import CartasTotales from '../Dialogos/CartasTotales.vue'
import CartasTotalesMiembros from '../Dialogos/CartasTotalesMiembros.vue'
import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable'
import * as XLSX from 'xlsx'
import { saveAs } from 'file-saver'
import { formatearFechaHora } from '@/utils/fechas';

export default {
    name: "Visitas",
    components: { PeriodoBusqueda, CartasTotales, CartasTotalesMiembros },

    data: () => ({
        busqueda: "",
        cargando: false,
        visitas: [],
        encabezadoTabla: [
            { text: "Imagen", sortable: true, value: "imagen" },
            { text: "Miembro", sortable: true, value: "nombre" },
            { text: "Matrícula", sortable: true, value: "matricula" },
            {
                text: "Fecha", sortable: true, value: "fecha",
                formatter: (value) => this.fechaFormateada(value)
            },
            { text: "Membresía ", sortable: true, value: "membresia" },
            { text: "Usuario", sortable: true, value: "usuario" },
        ],
        filtros: {
            fechaInicio: null,
            fechaFin: null
        },
        totalesMembresias: [],
        totalesUsuarios: [],
        totalesMiembros: []
    }),

    mounted() {
        this.obtenerVisitas()
    },

    methods: {
        fechaFormateada(fecha) {
            return formatearFechaHora(fecha);
        },
        generarExcel() {
            const ws = XLSX.utils.json_to_sheet(this.visitas.map(visitas => ({
                Miembro: visitas.nombre,
                Matrícula: visitas.matricula,
                Fecha: visitas.fecha,
                Membresía: visitas.membresia,
                Usuario: visitas.usuario
            })))

            const wb = XLSX.utils.book_new()
            XLSX.utils.book_append_sheet(wb, ws, 'Pagos')

            const wbout = XLSX.write(wb, { bookType: 'xlsx', type: 'array' })

            saveAs(new Blob([wbout], { type: 'application/octet-stream' }), 'reporte_visitas.xlsx')
        },
        generarPDF() {
            const doc = new jsPDF({ orientation: 'portrait', unit: 'pt', format: 'A4' });

            const pageWidth = doc.internal.pageSize.getWidth();

            // Dibujar el título centrado
            const title = "Reporte de Visitas";
            doc.setFontSize(18);
            doc.setFont('helvetica', 'bold');
            const textWidth = doc.getTextWidth(title);
            doc.text(title, (pageWidth - textWidth) / 2, 40);

            const columnas = [
                { header: 'Miembro', dataKey: 'nombre' },
                { header: 'Matrícula', dataKey: 'matricula' },
                { header: 'Fecha', dataKey: 'fecha' },
                { header: 'Membresía', dataKey: 'membresia' },
                { header: 'Cobró', dataKey: 'usuario' },
            ];

            autoTable(doc, {
                startY: 70,
                head: [columnas.map(col => col.header)],
                body: this.visitas.map(item => [
                    item.nombre,
                    item.matricula,
                    item.fecha,
                    item.membresia,
                    item.usuario
                ]),
                theme: 'striped',
                headStyles: {
                    fillColor: [41, 128, 185],
                    textColor: 255,
                    fontStyle: 'bold',
                },
                styles: {
                    fontSize: 10,
                    cellPadding: 5,
                },
                margin: { top: 70, bottom: 50 },
                didDrawPage: function (data) {
                    // Pie de página
                    const pageCount = doc.internal.getNumberOfPages();
                    const pageSize = doc.internal.pageSize;
                    const pageHeight = pageSize.height ? pageSize.height : pageSize.getHeight();

                    doc.setFontSize(10);
                    doc.setTextColor(150);
                    doc.text(`Página ${doc.internal.getCurrentPageInfo().pageNumber} de ${pageCount}`, pageWidth / 2, pageHeight - 20, { align: 'center' });
                },
            });

            doc.save('reporte_visitas.pdf');
        },
        onBuscar(fechas) {
            console.log(fechas)
            this.filtros = {
                fechaInicio: fechas[0],
                fechaFin: fechas[1]
            }

            this.obtenerVisitas()
        },

        urlImagen(imagen) {
            return Utiles.generarURL(imagen)
        },

        obtenerVisitas() {
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
            const tipo = (nombre && nombre.toLowerCase()) || ''
            if (tipo.includes('semanal')) return 'medalla-oro'
            if (tipo.includes('mensual hombre')) return 'medalla-plata'
            if (tipo.includes('mensual mujer')) return 'medalla-mujer'
            if (tipo.includes('mensual pareja / estudiante')) return 'medalla-bronce'
            if (tipo.includes('semestral')) return 'medalla-premium'
            return 'medalla-default'
        },

        iconoMembresia(nombre) {
            const tipo = (nombre && nombre.toLowerCase()) || ''
            if (tipo.includes('semanal')) return 'mdi-trophy'
            if (tipo.includes('mensual hombre')) return 'mdi-face-man'
            if (tipo.includes('mensual mujer')) return 'mdi-face-woman'
            if (tipo.includes('mensual pareja / estudiante')) return 'mdi-human-male-female'
            if (tipo.includes('semestral')) return 'mdi-calendar-range'
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
    border-radius: 16px;
    font-size: 0.875rem;
    color: #fff;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
}

.medalla-oro {
    background: linear-gradient(145deg, #0f4933, #21a572);
}

.medalla-plata {
    background: linear-gradient(145deg, #016e8f, #03bff8);
}

.medalla-bronce {
    background: linear-gradient(145deg, #cd3232, #b84333);
}

.medalla-mujer {
    background: linear-gradient(145deg, #7c1a43, #f35a9a);
}

.medalla-premium {
    background: linear-gradient(145deg, #6d1a7c, #b83bee);
}

.medalla-default {
    background: linear-gradient(145deg, #546E7A, #6c8692);
}
</style>