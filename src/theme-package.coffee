Package = require './package'

module.exports =
class ThemePackage extends Package
  getType: -> 'theme'

  getStyleSheetPriority: -> 1

  enable: ->
    atom.config.unshiftAtKeyPath('core.themes', @name)

  disable: ->
    atom.config.removeAtKeyPath('core.themes', @name)

  load: ->
    @loadTime = 0
    this

  activate: ->
    @activationPromise ?= new Promise (resolve, reject) =>
      @resolveActivationPromise = resolve
      @rejectActivationPromise = reject
      @measure 'activateTime', =>
        try
          @loadStylesheets()
          @activateNow()
        catch error
          @handleError("Failed to activate the #{@name} theme", error)
