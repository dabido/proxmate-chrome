define ['storage', 'config', 'jquery'], (StorageManager, ConfigProvider, $) ->
  init = ->
    exports.checkForUpdates()

  ###*
   * Downloads a list containing of ID and version
   * @param  {Function} callback callback to pass json on
  ###
  downloadVersionRepository = (callback) ->
    donationKey = StorageManager.get('donation_key')
    server = ConfigProvider.get('primary_server')
    updateUrl = "#{server}/package/update.json"
    if donationKey?
      donationKey = encodeURIComponent(donationKey)
      updateUrl = "#{server}/package/update.json?key=#{donationKey}"

    $.get updateUrl, (data) ->
      callback(data)

  ###*
   * Queries the primary server and checks for updates
  ###
  checkForUpdates = ->
    exports.downloadVersionRepository (versionRepository) ->
      installedPackages = StorageManager.get('installed_packages')
      # Compare and check for available updates
      for key, val of installedPackages
        # Check if the key exists in the downloaded list
        if key of versionRepository
          # If the version on the server is higher, reinstall the package
          if versionRepository[key] > val
            exports.installPackage(key)
          # -1 implied that the package is no longer available and marked for delete
          if versionRepository[key] == -1
            exports.removePackage(key)

  ###*
   * Installs / overrides package for key 'key'
   * @param  {String} key package identifier
   * @param {Function} callback callback function
  ###
  installPackage = (key, callback) ->
    callback = callback || ->

    server = ConfigProvider.get('primary_server')

    donationKey = StorageManager.get('donation_key')
    packageUrl = "#{server}/package/#{key}/install.json"
    if donationKey?
      donationKey = encodeURIComponent(donationKey)
      packageUrl = "#{server}/package/#{key}/install.json?key=#{donationKey}"

    $.ajax packageUrl,
      type: "GET",
      success: (packageData) ->
        # Query existing installed packages and add the new version / id
        installedPackages = StorageManager.get('installed_packages')
        if not installedPackages
          installedPackages = {}

        installedPackages[key] = packageData['version']

        StorageManager.set(key, packageData)
        StorageManager.set('installed_packages', installedPackages)

        require('runtime').restart()
        callback({success: true})
      error: (xhr) ->
        switch xhr.status
          when 401
            callback {success: false, message: xhr.responseJSON.message}
            return
          when 404
            callback {success: false, message: "The package you tried to install doesn't exist..."}
            return
          else
            callback {success: false, message: 'There was a problem installing this package.'}

  ###*
   * Returns all installed packages with their package contents
   * @return {Object} packages
  ###
  getInstalledPackages = ->
    # Query storage for all installed packages
    installedPackages = StorageManager.get('installed_packages')
    packageJson = []
    for id, version of installedPackages
      packageJson.push(StorageManager.get(id))

    return packageJson

  ###*
   * Removes a installed package
   * @param  {String} key package id
  ###
  removePackage = (key) ->
    # Kick the package out of the storage
    StorageManager.remove(key)
    # Remove it from versions array
    installedPackages = StorageManager.get('installed_packages')
    delete installedPackages[key]
    StorageManager.set('installed_packages', installedPackages)
    require('runtime').restart()

  exports = {
    init: init
    checkForUpdates: checkForUpdates
    downloadVersionRepository: downloadVersionRepository
    installPackage: installPackage
    getInstalledPackages: getInstalledPackages
    removePackage: removePackage
  }

  return exports
