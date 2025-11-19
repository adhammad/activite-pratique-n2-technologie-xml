# Gestion des Relevés Bancaires - Questions & Réponses

## Question 1️⃣ : Structure graphique de l'arbre XML

```
releve (RIB)
├── dateReleve
├── solde
└── operations (dateDebut, dateFin)
    ├── operation (type, date, montant, description)
    ├── operation (type, date, montant, description)
    ├── operation (type, date, montant, description)
    └── operation (type, date, montant, description)
```

---

## Question 2️⃣ : DTD et Document XML valide

### DTD : `releve_bancaire.dtd`

```xml
<?xml version="1.0" encoding="UTF-8"?>

<!ELEMENT releve (dateReleve, solde, operations)>
<!ATTLIST releve RIB CDATA #REQUIRED>

<!ELEMENT dateReleve (#PCDATA)>
<!ELEMENT solde (#PCDATA)>

<!ELEMENT operations (operation*)>
<!ATTLIST operations dateDebut CDATA #REQUIRED>
<!ATTLIST operations dateFin CDATA #REQUIRED>

<!ELEMENT operation EMPTY>
<!ATTLIST operation type (CREDIT | DEBIT) #REQUIRED>
<!ATTLIST operation date CDATA #REQUIRED>
<!ATTLIST operation montant CDATA #REQUIRED>
<!ATTLIST operation description CDATA #REQUIRED>
```

### Document XML valide avec DTD

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE releve SYSTEM "releve_bancaire.dtd">
<releve RIB="011112222333344445555666">
    <dateReleve>2021-01-30</dateReleve>
    <solde>76470</solde>
    <operations dateDebut="2021-01-01" dateFin="2021-01-30">
        <operation type="CREDIT" date="2021-01-01" montant="9000" description="Vers Espèce"/>
        <operation type="DEBIT" date="2021-01-11" montant="3400" description="Chèque Guichet"/>
        <operation type="DEBIT" date="2021-01-15" montant="120" description="Prélèvement Assurance"/>
        <operation type="CREDIT" date="2021-01-25" montant="70000" description="Virement Salaire"/>
    </operations>
</releve>
```

---

## Question 3️⃣ : Schéma XSD et Document XML valide

### Schéma XSD : `releve_bancaire.xsd`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xs:element name="releve">
        <xs:complexType>
            <xs:sequence>
                <xs:element name="dateReleve" type="xs:date"/>
                <xs:element name="solde" type="xs:decimal"/>
                <xs:element name="operations" type="operationsType"/>
            </xs:sequence>
            <xs:attribute name="RIB" type="xs:string" use="required"/>
        </xs:complexType>
    </xs:element>

    <xs:complexType name="operationsType">
        <xs:sequence>
            <xs:element name="operation" type="operationType" minOccurs="0" maxOccurs="unbounded"/>
        </xs:sequence>
        <xs:attribute name="dateDebut" type="xs:date" use="required"/>
        <xs:attribute name="dateFin" type="xs:date" use="required"/>
    </xs:complexType>

    <xs:complexType name="operationType">
        <xs:simpleContent>
            <xs:extension base="xs:string">
                <xs:attribute name="type" use="required">
                    <xs:simpleType>
                        <xs:restriction base="xs:string">
                            <xs:enumeration value="CREDIT"/>
                            <xs:enumeration value="DEBIT"/>
                        </xs:restriction>
                    </xs:simpleType>
                </xs:attribute>
                <xs:attribute name="date" type="xs:date" use="required"/>
                <xs:attribute name="montant" type="xs:decimal" use="required"/>
                <xs:attribute name="description" type="xs:string" use="required"/>
            </xs:extension>
        </xs:simpleContent>
    </xs:complexType>

</xs:schema>
```

### Document XML valide avec Schéma XSD

```xml
<?xml version="1.0" encoding="UTF-8"?>
<releve xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="releve_bancaire.xsd"
        RIB="011112222333344445555666">
    <dateReleve>2021-01-30</dateReleve>
    <solde>76470</solde>
    <operations dateDebut="2021-01-01" dateFin="2021-01-30">
        <operation type="CREDIT" date="2021-01-01" montant="9000" description="Vers Espèce"/>
        <operation type="DEBIT" date="2021-01-11" montant="3400" description="Chèque Guichet"/>
        <operation type="DEBIT" date="2021-01-15" montant="120" description="Prélèvement Assurance"/>
        <operation type="CREDIT" date="2021-01-25" montant="70000" description="Virement Salaire"/>
    </operations>
</releve>
```

---

## Question 4️⃣ : XSL pour afficher TOUTES les données + totaux

### Feuille XSL : `releve_complet.xsl`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

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
                        <div class="info-item"><span class="label">RIB :</span> <xsl:value-of select="releve/@RIB"/></div>
                        <div class="info-item"><span class="label">Date du Relevé :</span> <xsl:value-of select="releve/dateReleve"/></div>
                        <div class="info-item"><span class="label">Solde :</span> <xsl:value-of select="releve/solde"/> €</div>
                        <div class="info-item"><span class="label">Période :</span> <xsl:value-of select="releve/operations/@dateDebut"/> à <xsl:value-of select="releve/operations/@dateFin"/></div>
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
                                            <xsl:when test="@type='CREDIT'"><span class="credit">CRÉDIT</span></xsl:when>
                                            <xsl:otherwise><span class="debit">DÉBIT</span></xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                    <td><xsl:value-of select="@description"/></td>
                                    <td>
                                        <xsl:choose>
                                            <xsl:when test="@type='CREDIT'"><span class="credit">+ <xsl:value-of select="@montant"/> €</span></xsl:when>
                                            <xsl:otherwise><span class="debit">- <xsl:value-of select="@montant"/> €</span></xsl:otherwise>
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
```

---

## Question 5️⃣ : XSL pour afficher les opérations CREDIT uniquement

### Feuille XSL : `releve_credits.xsl`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

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
                        <div class="info-item"><span class="label">RIB :</span> <xsl:value-of select="releve/@RIB"/></div>
                        <div class="info-item"><span class="label">Période :</span> <xsl:value-of select="releve/operations/@dateDebut"/> à <xsl:value-of select="releve/operations/@dateFin"/></div>
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
                            <div class="no-data">Aucune opération de crédit pour cette période.</div>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
```

---

## Résumé des fichiers à créer

| Fichier | Type | Description |
|---------|------|-------------|
| `releve_bancaire.dtd` | DTD | Validation avec DTD |
| `releve_bancaire.xsd` | XSD | Validation avec Schéma XML |
| `releve_complet.xsl` | XSLT | Affichage complet + totaux |
| `releve_credits.xsl` | XSLT | Affichage crédits uniquement |
