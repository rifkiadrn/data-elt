package config

import (
	"github.com/go-playground/validator/v10"
	"github.com/gofiber/fiber/v2"

	"github.com/rifkiadrn/data-elt/internal/handler/rest"
	"github.com/rifkiadrn/data-elt/internal/handler/rest/middleware"
	"github.com/rifkiadrn/data-elt/internal/handler/rest/router"
	"github.com/rifkiadrn/data-elt/internal/repository"
	"github.com/rifkiadrn/data-elt/internal/usecase"
	"github.com/rifkiadrn/data-elt/internal/utils"
	"github.com/sirupsen/logrus"
	"github.com/spf13/viper"
	"gorm.io/gorm"
)

type BootstrapConfig struct {
	DB       *gorm.DB
	App      *fiber.App
	Log      *logrus.Logger
	Validate *validator.Validate
	Config   *viper.Viper
}

func Bootstrap(config *BootstrapConfig) {
	// setup repositories
	userRepository := repository.NewUserRepository(config.Log)

	// setup JWT manager
	jwtManager := utils.NewJWTManager(config.Config.GetString("SECRET_KEY")) // TODO: move to config

	// setup use cases
	userUseCase := usecase.NewUserUseCase(config.DB, config.Log, config.Validate, userRepository, jwtManager)

	userHandler := rest.NewUserHandler(userUseCase, config.Log)

	genericHandler := rest.NewGenericHandler(config.Log)

	// setup handler
	apiHandler := rest.NewAPIHandler(genericHandler, userHandler)

	// setup middleware
	authMiddleware := middleware.NewAuth(userUseCase, config.Log)

	routerConfig := router.RouterConfig{
		App:            config.App,
		Log:            config.Log,
		APIHandler:     *apiHandler,
		AuthMiddleware: authMiddleware,
	}
	routerConfig.Setup()
}
