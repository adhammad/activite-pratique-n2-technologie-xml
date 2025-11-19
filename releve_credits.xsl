<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="/">
        <html>
            <head>
                <title>Opérations de Crédit</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
                    .container { background-color: white; padding: 20px; border-radius: 5px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); max-width: 900px; margin: 0 auto; }
                    h1 { color: #155724; border-bottom: 3px solid #28a745; padding-bottom: 10px; }
                    .info { margin: 15px 0; padding: 10px; background-color: #d4edda; border-left: 4px solid #28a745; }
                    .info-item { margin: 5px 0; }
                    .label { font-weight: bold; color: #155724; }
                    table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                    th { background-color: #28a745; color: white; padding: 12px; text-align: left; }
                    td { padding: 10px; border-bottom: 1px solid #ddd; }
                    tr:hover { background-color: #f0fdf4; }
                    .montant { color: #155724; font-weight: bold; }
                    .total-row { background-color: #d4edda; font-weight: bold; }
                    .total-montant { color: #155724; font-size: 16px; }
                    .no-data { text-align: center; padding: 20px; color: #666; font-style: italic; }
                </style>
            </head>
            <body>
                <div class="container">
                    <h1>Opérations de Crédit</h1>
                    
                    <div class="info">
                        <div class="info-item">
                            <span class="label">RIB :</span>
                            <xsl:value-of select="releve/@RIB"/>
                        </div>
                        <div class="info-item">
                            <span class="label">Période :</span>
                            <xsl:value-of select="releve/operations/@dateDebut"/> à <xsl:value-of select="releve/operations/@dateFin"/>
                        </div>
                    </div>

                    <xsl:choose>
                        <xsl:when test="count(releve/operations/operation[@type='CREDIT']) > 0">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Description</th>
                                        <th>Montant</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <xsl:for-each select="releve/operations/operation[@type='CREDIT']">
                                        <xsl:sort select="@date" order="ascending"/>
                                        <tr>
                                            <td><xsl:value-of select="@date"/></td>
                                            <td><xsl:value-of select="@description"/></td>
                                            <td class="montant">+ <xsl:value-of select="@montant"/> €</td>
                                        </tr>
                                    </xsl:for-each>
                                    <tr class="total-row">
                                        <td colspan="2">Total des Crédits</td>
                                        <td class="total-montant">+ <xsl:value-of select="sum(releve/operations/operation[@type='CREDIT']/@montant)"/> €</td>
                                    </tr>
                                </tbody>
                            </table>
                        </xsl:when>
                        <xsl:otherwise>
                            <div class="no-data">
                                Aucune opération de crédit pour cette période.
                            </div>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>