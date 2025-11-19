<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="/">
        <html>
            <head>
                <title>Relevé Bancaire</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
                    .container { background-color: white; padding: 20px; border-radius: 5px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); max-width: 900px; margin: 0 auto; }
                    h1 { color: #333; border-bottom: 2px solid #007bff; padding-bottom: 10px; }
                    .info { margin: 15px 0; padding: 10px; background-color: #f0f0f0; border-left: 4px solid #007bff; }
                    .info-item { margin: 5px 0; }
                    .label { font-weight: bold; color: #333; }
                    table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                    th { background-color: #007bff; color: white; padding: 12px; text-align: left; }
                    td { padding: 10px; border-bottom: 1px solid #ddd; }
                    tr:hover { background-color: #f9f9f9; }
                    .credit { color: green; font-weight: bold; }
                    .debit { color: red; font-weight: bold; }
                    .totaux { background-color: #f0f0f0; font-weight: bold; }
                    .total-credit { color: green; }
                    .total-debit { color: red; }
                </style>
            </head>
            <body>
                <div class="container">
                    <h1>Relevé de Compte Bancaire</h1>
                    
                    <div class="info">
                        <div class="info-item">
                            <span class="label">RIB :</span>
                            <xsl:value-of select="releve/@RIB"/>
                        </div>
                        <div class="info-item">
                            <span class="label">Date du Relevé :</span>
                            <xsl:value-of select="releve/dateReleve"/>
                        </div>
                        <div class="info-item">
                            <span class="label">Solde :</span>
                            <xsl:value-of select="releve/solde"/> €
                        </div>
                        <div class="info-item">
                            <span class="label">Période :</span>
                            <xsl:value-of select="releve/operations/@dateDebut"/> à <xsl:value-of select="releve/operations/@dateFin"/>
                        </div>
                    </div>

                    <table>
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Type</th>
                                <th>Description</th>
                                <th>Montant</th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each select="releve/operations/operation">
                                <tr>
                                    <td><xsl:value-of select="@date"/></td>
                                    <td>
                                        <xsl:choose>
                                            <xsl:when test="@type='CREDIT'">
                                                <span class="credit">CRÉDIT</span>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <span class="debit">DÉBIT</span>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                    <td><xsl:value-of select="@description"/></td>
                                    <td>
                                        <xsl:choose>
                                            <xsl:when test="@type='CREDIT'">
                                                <span class="credit">+ <xsl:value-of select="@montant"/> €</span>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <span class="debit">- <xsl:value-of select="@montant"/> €</span>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                </tr>
                            </xsl:for-each>
                            <tr class="totaux">
                                <td colspan="2"></td>
                                <td>Total Crédits :</td>
                                <td class="total-credit">+ <xsl:value-of select="sum(releve/operations/operation[@type='CREDIT']/@montant)"/> €</td>
                            </tr>
                            <tr class="totaux">
                                <td colspan="2"></td>
                                <td>Total Débits :</td>
                                <td class="total-debit">- <xsl:value-of select="sum(releve/operations/operation[@type='DEBIT']/@montant)"/> €</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>