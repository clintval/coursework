# Clint Valentine
# 03/05/2017

rm(list = ls())

myVariant <- function(q, fields='all', size=10, from=0, email='') {
  # Returns a data.frame of genomic variants from the myVariant REST API.
  # Documentation for the service can be found at http://myvariant.info/.
  #
  # Args:
  #   q: a string or named list of key:value pairs as described in the 
  #       following documentation: (http://docs.myvariant.info/en/latest/doc/
  #       variant_query_service.html#get-request)
  #   fields: fields to return for the matches of the query [e.g. cosmic].
  #   size: amount of requests to return [max 1000].
  #   from: useful for paging requests 1000 at a time using the same query.
  #   email: tell myVariant who you are for improved support.
  #
  # Returns:
  #   data.frame of genomic variants that suit the query request.
  
  # Function level libraries for portability
  require(httr)
  require(jsonlite)
  require(stringr)
  
  if ( is.list(q) ) {
    # Assemble query using the name:key in queryParams named list.
    queryParams <- rep('', length(q))
    for ( i in 1:length(q) ) {
      queryParams[i] = paste(names(q)[i], ':', q[[i]], sep='')
    }
    # For all query syntax, concatenate with boolean operator AND.
    q <- paste(queryParams, collapse=' AND ')}
  else if ( !is.character(q) ) {
    stop("Please provide a string or named list.")
  }

  # Build the final query for the GET request.
  query <- list(
    q = q,
    size = size,
    from = from,
    fields = fields,
    email = email)
  
  # GET the request from the HTTP API service.
  r <- GET('http://myvariant.info/', path = 'v1/query', query = query)
  
  # If an error code is returned then raise error.
  stop_for_status(r)

  # Convert the returned JSON text to a data.frame and select only returned
  # values as defined by `hits`.
  return(fromJSON(content(r, 'text'))[['hits']])
}

# USAGE #######################################################################

# Define a list of query parameters per myVariant.info spec.
query <- list(
  cosmic.tumor_site = 'liver',
  cosmic.alt = 'G'
)

# Process that request using the wrapper above. In this case we are looking for
# the first five variants from the COSMIC database from liver tumors where the
# variant allele is a guanine residue. Use my personal email address to allow
# myVariant.info to log my requests.
mutations <- myVariant(query, fields='cosmic', size=5,
                       email='valentine.clint@gmail.com')
# Print the resultant data.frame.
print(mutations)


# TESTING #####################################################################

testMyVariant <- function() {
  # Tests one call to the API for a specific variant. This variant exists on
  # chromosome 1 of the hg19 build at position 69117 and is of the substitution
  # type T>A.
  q <- 'chr1:69117 AND vcf.alt:A AND vcf.ref:T'
  result <- myVariant(q=q)
  
  # Ensure correct non-degenerate variant object identifier _id is returned.
  cat("\n")
  cat("Testing query:  ", q, "\n")
  cat("Result:         ", result[['_id']], "\n")
  cat("Passing Check:  ", result[['_id']] == 'chr1:g.69117T>A')
}

testMyVariant()
# $ testMyVariant()
#   Testing query:   chr1:69117 AND vcf.alt:A AND vcf.ref:T 
#   Result:          chr1:g.69117T>A 
#   Passing Check:   TRUE
#
