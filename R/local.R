#' Measures based on the neighborhood of each node
#'
#' These functions wraps a set of functions that all measures quantities of the
#' local neighborhood of each node.
#'
#' @param ... Parameters passed on to the `igraph` function in question
#'
#' @return A numeric vector or a list (for `local_members`) with elements
#' corresponding to the nodes in the graph.
#'
#' @name local_graph
#' @rdname local_graph
#'
#' @examples
#' # Get all neighbors of each graph
#' create_notable('chvatal') %>%
#'   activate(nodes) %>%
#'   mutate(neighborhood = local_members(mindist = 1))
#'
#' # These are equivalent
#' create_notable('chvatal') %>%
#'   activate(nodes) %>%
#'   mutate(n_neighbors = local_size(mindist = 1),
#'          degree = centrality_degree()) %>%
#'   as_tibble()
#'
NULL

#' @describeIn local_graph The size of the neighborhood in a given distance from
#' the node. (Note that the node itself is included unless `mindist > 0`). Wraps [igraph::ego_size()].
#' @inheritParams igraph::ego_size
#' @importFrom igraph ego_size
#' @export
local_size <- function(order = 1, mode = 'all', mindist = 0) {
  expect_nodes()
  ego_size(graph = .G(), order = order, mode = mode, mindist = mindist)
}
#' @describeIn local_graph The members of the neighborhood of each node in a
#' given distance. Wraps [igraph::ego()].
#' @importFrom igraph ego
#' @export
local_members <- function(order = 1, mode = 'all', mindist = 0) {
  expect_nodes()
  lapply(ego(graph = .G(), order = order, mode = mode, mindist = mindist), as.integer)
}
#' @describeIn local_graph The number of triangles each node participate in. Wraps [igraph::count_triangles()].
#' @importFrom igraph count_triangles
#' @export
local_triangles <- function() {
  expect_nodes()
  count_triangles(graph = .G())
}
#' @describeIn local_graph Calculates the average degree of based on the neighborhood of each node. Wraps [igraph::knn()].
#' @inheritParams igraph::knn
#' @importFrom igraph knn
#' @export
local_ave_degree <- function(weights = NULL) {
  expect_nodes()
  knn(graph = .G(), weights = weights)
}
#' @describeIn local_graph Calculate the transitivity of each node, that is, the
#' propensity for the nodes neighbors to be connected. Wraps [igraph::transitivity()]
#' @importFrom igraph transitivity V
#' @importFrom rlang quos
#' @export
local_transitivity <- function(...) {
  expect_nodes()
  dots <- quos(...)
  type <- if (is.null(dots$weights)) {
    'weighted'
  } else {
    'local'
  }
  graph <- .G()
  transitivity(graph = graph, type = type, vids = V(graph), ...)
}
