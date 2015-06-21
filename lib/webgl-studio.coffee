ipc = require('ipc')
{CompositeDisposable} = require 'event-kit'
RenderModel = require './render-model'
RenderView = require './render-view'

module.exports = wgls =
  pickFolderResponse: "webgl-studio-pick-folder-response"

  serialize: ->
    {"project": @project.serialize()}

  deactivate: ->

  activate: (@state) ->
    atom.webglStudio = @

    @project = atom.deserializers.deserialize(@state.project) ? new atom.project.constructor()

    @disposables = new CompositeDisposable
    @disposables.add atom.commands.add 'atom-workspace',
      'webgl-studio-open-project': => openProject()

    atom.views.addViewProvider {modelConstructor: RenderModel, viewConstructor: RenderView}

    ipc.on @pickFolderResponse, (paths = []) =>
      console.log(paths)
      @project.addPath(path) for path in paths

    packageRoot = atom.packages.resolvePackagePath('webgl-studio')
    path = packageRoot + "/static/new-rendering.html"
    #createNewRendering(path)

createNewRendering = (path) ->
  model = new RenderModel(path)
  view = atom.views.getView(model)

openProject = ->
  ipc.send('pick-folder', wgls.pickFolderResponse)
