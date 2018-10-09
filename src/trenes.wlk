/**
 * Clase Tren
 */
class Tren {

  var locomotoras
  const vagones

  constructor(_locomotoras, _vagones) {
    locomotoras = _locomotoras
    vagones = _vagones
  }

  method cantidadDePasajeros() {
    return vagones.sum({ vagon => vagon.cantidadDePasajeros() })
  }

  method cantidadDeVagonesLivianos() {
    return vagones.filter({ vagon => vagon.pesoMaximo() < 2500 }).size()
  }

  method velocidadMaximaLocomotoras() {
    return locomotoras.min({ locomotora => locomotora.velocidadMaxima() }).velocidadMaxima()
  }

  method velocidadMaxima() {
    return locomotoras.sortedBy({ loc1 , loc2 => loc1.velocidadMaxima() < loc2.velocidadMaxima() }).first().velocidadMaxima()
  }

  method esEficiente() {
    return locomotoras.all({ locomotora => locomotora.cuantoPuedeArrastrar() > locomotora.peso() * 5 })
  }

  method cuantoEmpujeFalta() {
    var pesoMaximoVagones = vagones.sum({ vagon => vagon.pesoMaximo() })
    var arrastreLocomotoras = locomotoras.sum({ locomotora => locomotora.cuantoPuedeArrastrar() })
    if (arrastreLocomotoras < pesoMaximoVagones) {
      return (pesoMaximoVagones - arrastreLocomotoras)
    }
    return 0
  }

  method puedeMoverse() = self.cuantoEmpujeFalta() === 0

  method vagonMasPesado() {
    return vagones.sortedBy({ vag1 , vag2 => vag1.pesoMaximo() > vag2.pesoMaximo() }).first()
  }

  method esCompleja() {
    var totalUnidades = vagones.size() + locomotoras.size()
    var pesoVagones = vagones.sum({ vagon => vagon.pesoMaximo() })
    var pesoLocomotoras = locomotoras.sum({ locomotora => locomotora.peso() })
    var pesoTotal = pesoVagones + pesoLocomotoras
    if (totalUnidades > 20 || pesoTotal > 10000) {
      return true
    }
    return false
  }

  method agregarLocomotora(_locomotora) {
    locomotoras.add(_locomotora)
  }

}

/**
 * Clase TrenCortaDistancia
 */
class TrenCortaDistancia inherits Tren {

  method estaBienArmada() = self.puedeMoverse() && not self.esCompleja()

  override method velocidadMaxima() = self.velocidadMaximaLocomotoras().min(60)

}

/**
 * Clase TrenLargaDistancia
 */
class TrenLargaDistancia inherits Tren {

  var property origen = null
  var property destino = null

  method cantidadDeBanios() = vagones.sum({ vagon => vagon.cantidadDeBanios() })

  method estaBienArmada() = self.cantidadDeBanios() > self.cantidadDePasajeros() / 50

  method velocidadMaximaLegal() = if (origen.esGrande() and destino.esGrande()) 200 else 150

  override method velocidadMaxima() = self.velocidadMaximaLocomotoras().min(self.velocidadMaximaLegal())

}

/**
 * Clase TrenAltaVelocidad
 */
class TrenAltaVelocidad inherits TrenLargaDistancia {

  override method velocidadMaxima() = self.velocidadMaximaLocomotoras().min(400)

  override method estaBienArmada() = self.velocidadMaxima() >= 250 and self.cantidadDeVagonesLivianos() === vagones.size()

}
