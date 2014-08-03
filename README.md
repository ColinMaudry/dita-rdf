The DITA RDF project
====================

The objective of this project is to develop an ontology to describe DITA XML objects and to publish tools to generate RDF triples based on that ontology. In the end, it enables the publication of the metadata of a DITA documentation set to the Semantic Web and consequently its linking with other data types (product, people, sales, non-DITA document metadata, etc.).

See the useful links below if you want to know more about the Semantic Web.

## Status

 * The ontology is already available as a Turtle file, [dita.ttl](https://github.com/ColinMaudry/dita-rdf/blob/master/dita.ttl). It can also be viewed [here](http://purl.org/dita/ns#) in a more human-readable form (to be improved!), and [here](http://bit.ly/DitaRdfLucidChart) as a graphic.
 * A DITA Open toolkit plugin is available [here](https://github.com/ColinMaudry/dita-rdf/blob/master/dita2rdf/dita2rdf-ditaot-plugin.zip) (documentation [here](./dita2rdf)) to enable the extraction of RDF triples from DITA content ([RDF output example](http://colin.maudry.com/rdf/userguide.rdf)). The following metadata is extracted (including specializations) for maps and topics:
	- @id
	- title
	- language
	- author
	- topicref/@href
	- [rdf:type](http://www.w3.org/TR/rdf-schema/#ch_type), including super classes (e.g. dita:Map and dita:Bookmap for a bookmap)
 * The plugin will be adapted to be used in [Componize for Alfresco](http://www.componize.com)
 * A tutorial will be written to publish the RDF triples resulting from the transformation to a triple store and query your DITA metadata

## Useful links

 - A very good introduction to RDF, the Semantic Web, and how it completes XML: http://www.cambridgesemantics.com/semantic-university/rdf-101
 - The official page of the Semantic Web: http://www.w3.org/standards/semanticweb/

The DITA RDF ontology is licensed under a under a Creative Commons BY-SA 3.0 license (http://creativecommons.org/licenses/by-sa/3.0/).

The DITA RDF DITA Open toolkit plugin is licensed under the GNU Public License version 3 (https://gnu.org/licenses/gpl.html).

## Contact

* Twitter: [@CMaudry](https://www.twitter.com/ColinMaudry)
* Email: colin@maudry.com

## Objective

This ontology is not meant to serve as an alternative to the standard DITA 1.2 DTDs and schemas. It translates the semantics of a subset of the vocabulary described in the [DITA 1.2 specification](http://docs.oasis-open.org/dita/v1.2/os/spec/DITA1.2-spec.html) in a format that can be understood in the Semantic Web of data.

[This poster](http://bit.ly/DitaRdfPoster) illustrates the objective of the project. I presented it during the 10th Summer School on Ontology Engineering and the Semantic Web ([SSSW 2013](http://sssw.org/2013/)).

## Scope

This ontology does not aim at completeness (the whole DITA 1.2 language specification) but at covering the metadata that describes DITA content.

The scope of this ontology includes the meaningful elements and attributes of the [DITA 1.2 vocabulary]. I focused on the metadata elements that are derived from [Dublin core](http://dublincore.org/documents/dcmi-terms/) (title, author, etc) and on the relationships between maps, topics and other documents. 

The scope of this ontology does not include the elements and attributes that bear little semantics, such as (not exhaustive):

* highlight domain (underline, bold, italic, etc.)
* hazard domain
* paragraphs
* tables
* lists
* sections

Also, it does not include (yet) the elements that bear semantics but that my company doesn' use. I will add them, but you can ping me if you would like to see them added (not exhaustive):

* metadata specific to DITA specializations (learning, machinery, semiconductors, etc.)
* the programming, indexing, software, utilities and UI domains (will add them as separate modules)
* category

## Base ontologies

I have chosen to use the Nepomuk ontologies [NIE](http://www.semanticdesktop.org/ontologies/2007/01/19/nie) and [NFO](http://www.semanticdesktop.org/ontologies/2007/03/22/nfo), and specialize the classes. The distinction they make between data objects (sequences of bytes) and information elements (interpretations) prevents the confusion between:

* the file as data on a file system, that has a path and can be moved or renamed
* the information contained in this file that results from its interpretation (by an XML editor or a PDF viewer).

For instance, let's consider a DITA topic. If the topic is renamed, can we consider that the topic was modified? The file was modified, but the meaning born by the topic remains untouched.

## Background

This idea came to me when we (NXP Customer Documentation Services) [decided](http://blog.nxp.com/is-linked-data-the-future-of-data-integration-in-the-enterprise/) to publish the metadata of our products and documents as RDF in order to end the siloization of our various data types, define company-wide data models and so that external organizations can easily consume this data.

I have already set up the publication of the metadata about binary documents (data sheets, user manuals, etc.), but since our DITA content is built on complex relationships (topic reuse) and our primary format for translation, we need a proper ontology to describe it. The driver is to provide detailed metrics to authors and greatly facilitate certain internal processes such as the selection of the content to translate. Indeed, we consider that being able to formulate multidimensional queries across topics, maps, users, products and company divisions is a major step ahead.

The driver is consequently mostly internal, but we plan to publish a subset of this metadata when we go live with the whole public data set. Follow [@nxpdata](https://www.twitter.com/nxpdata) to get the latest updates about the linked data published by NXP.

Finally, since the challenges we face are most likely similar to the ones other DITA-enabled organizations face, I decided to share my findings.

_TODO add links to real-life RDF samples._

## Publishing method and availability

The namespace base URI is http://purl.org/dita/ns# and the recommended prefix is **dita:**.

By default this URI returns the XHTML version of the ontology, but it also supports content negotiation for RDF/XML and Turtle ([Vapour test](http://uriburner.com:8000/vapour?uri=http%3A%2F%2Fpurl.org%2Fdita%2Fns%23&acceptRdfXml=1&acceptJsonLD=1&htmlVersions=1&defaultResponse=rdfxml&userAgent=vapour.sourceforge.net)).

The ontology is written in a Turtle file and converted to various serializations using an public Web service (http://rdf.greggkellogg.net/distiller):

* Turtle ([download](http://colin.maudry.com/ontologies/dita.ttl))
* RDF/XML ([download](http://colin.maudry.com/ontologies/dita.rdf))
* JSON-LD ([download](http://colin.maudry.com/ontologies/dita.jsonld))

The Turtle version is the truth. Feel free to checkout the Git project and contribute.

A graphical representation of the DITA RDF model can be [viewed on LucidChart](http://bit.ly/DitaRdfLucidChart).

##Public domain

The DITA RDF ontology, the DITA RDF plugin and all the code included in the DITA RDF project are free and released into the public domain, excepted the parts that were reused from the pdf2 DITA-OT plugin, developed by Idiom Inc.

See [UNLICENSE](UNLICENSE) for the whole shebang.

If you find the DITA RDF project useful, I would be grateful if you tweet about it (something like "kudos @CMaudry!") or if you mention the origin and the author of this software in the documentation of your product.
