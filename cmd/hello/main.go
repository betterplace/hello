package main

import (
	"log"
	"net/http"

	hello "github.com/betterplace/betterplace-hello"
	"github.com/kelseyhightower/envconfig"
	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
)

func main() {
	var config hello.Config
	err := envconfig.Process("", &config)
	if err != nil {
		log.Fatal(err)
	}

	e := echo.New()
	e.Use(middleware.Logger())

	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "Hello, Betterplace!\n")
	})

	e.Logger.Fatal(e.Start(":" + config.PORT))
}
