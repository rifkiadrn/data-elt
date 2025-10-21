package rest

// aggregate struct
type APIHandler struct {
	*GenericHandler
	*UserHandler
}

// constructor
func NewAPIHandler(generic *GenericHandler, user *UserHandler) *APIHandler {
	return &APIHandler{generic, user}
}
