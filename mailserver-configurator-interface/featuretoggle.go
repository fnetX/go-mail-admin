package main

import (
	"github.com/unrolled/render"
	"net/http"
)

type featureToggles struct {
	CatchAll bool `json:"catchall"`
}

func NewFeatureToggleFromEnv() *featureToggles {
	ft := featureToggles{}
	//Catchall
	ft.CatchAll = false
	if getConfigVariable("CATCHALL") == "On" {
		ft.CatchAll = true
	}

	return &ft
}

func getFeatureToggles(w http.ResponseWriter, r *http.Request) {
	ft := NewFeatureToggleFromEnv()
	ren := render.New()
	ren.JSON(w, http.StatusOK, ft)
}