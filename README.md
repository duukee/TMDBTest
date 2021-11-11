# TMDBTest
App para iOS que muestra un listado de películas destacadas haciendo uso de la API de "The Movie Database". 
Además la app dispone de un buscador que permite encontrar cualquier película de esta base de datos.

La aplicación está desarrollada siguiento el patrón MVP. 
Cada viewcontroller tiene un presenter que es el encargado de solicitar los datos del DataSource 
y comunicarse con la vista para que ésta muestre la información correspondiente (listado o alertas), entregándole los datos cuando corresponda.

El acceso a los datos se hace mediante un DataSource, que en este caso se los pide al APICaller, pero está así pensado para que en el caso de existir
CoreData en el proyecto, este DataSource sería el encargado de controlar si disponemos de los datos en la base local o debe pedirlos al servicio REST.
