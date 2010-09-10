<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://exslt.org/common">
  <xsl:variable name="textTemp">
    <translations>
      <product_item en="Item" no="Produkt"/>
      <no_items en="No items in shopping cart" no="Handlekurven er tom"/>
      <no_products en="No items are published in this category" no="Ingen produkter er publisert i denne kategorien"/>
      <and en="and" no="og"/>
      <photo en="Photo" no="Foto"/>
      <back en="Back" no="Tilbake"/>
      <to_top en="Top" no="Til toppen"/>
      <related_items en="Accessories" no="Tilbehør"/>
      <link en="Link" no="Lenke" sv="Länk"/>
      <description en="Description" no="Beskrivelse" sv="Beskrivning"/>
      <related_files en="Related files" no="Relaterte filer" sv="Relaterade filer"/>
      <filename en="Filename" no="Filnavn" sv="Filnamn"/>
      <date en="Date" no="Dato" sv="Datum"/>
      <size en="Size" no="Str" sv="Storlek"/>
      <item en="Product" no="Produkt"/>
      <product_number en="Product number" no="Produktnummer"/>
      <vat en="VAT" no="Herav MVA"/>
      <your_order en="Your order" no="Din ordre"/>
      <price en="Retail price" no="Utsalgspris"/>
      <continue_shopping en="Continue shopping" no="Fortsett å handle"/>
      <empty_basket en="Empty shopping cart" no="Tøm handlekurv"/>
      <submit_order en="Submit order" no="Send bestilling"/>
      <quantity en="Quantity" no="Antall"/>
      <add_to_cart en="Add to shopping cart" no="Legg i handlekurv"/>
      <update_cart en="Update" no="Oppdatér"/>
      <delete en="Delete" no="Slett"/>
      <total en="Total" no="Totalt"/>
      <view_basket en="View shopping cart" no="Se handlekurv"/>
      <items_in_basket en="Items in shopping cart" no="Varer i handlekurven"/>    
      <account_information en="Account information" no="Kundeinformasjon"/>
      <account_number en="Acccount number" no="Kundenummer"/>
      <account_firstname en="Firstname" no="Fornavn"/>
      <account_surname en="Surname" no="Etternavn"/>
      <account_company en="Company" no="Firma"/>
      <account_email en="E-mail" no="E-post"/>
      <account_phone en="Phone" no="Telefon"/>
      <account_address en="Address" no="Adresse"/>
      <account_postalcode en="Postal code" no="Poststed"/>
      <account_postalnumber en="Postal number" no="Postnummer"/>
      <account_country en="Country" no="Land"/>
      <account_comments en="Additional comments" no="Eventuelle tilleggsopplysninger"/>
      <account_submit en="Submit" no="Send skjema"/>
      <account_reset en="Reset" no="Nullstill"/>
    </translations>
  </xsl:variable>
  <xsl:variable name="textTemp2">
    <xsl:apply-templates select="$textTemp/translations/*"/>
  </xsl:variable>
  <xsl:variable name="translations" select="$textTemp2"/>
  <xsl:template match="*">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="@*[name() = $language] != ''">
          <xsl:value-of select="@*[name() = $language]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>[NOT TRANSLATED]</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>