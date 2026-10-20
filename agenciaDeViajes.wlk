class Pack {
  const property duracion
  const property precioBase
  var property coordinador
  var property beneficios = []

  method beneficiosVigentes() = beneficios.filter({ b => b.estaVigente() })

  method costoBeneficiosVigentes() = self.beneficiosVigentes().sum(
    { b => b.costo() }
  )

  method valorFinal() = precioBase + self.costoBeneficiosVigentes()

  method esPremium()
}

class PackNacional inherits Pack {
  const property provinciaDestino
  var property listaDeActividades = []

  override method esPremium() = (duracion > 10) and coordinador.altamenteCalificado()
}

class PackProvincial inherits PackNacional {
  const property cantidadDeCiudades

  override method esPremium() = ((listaDeActividades.size() >= 4) and (cantidadDeCiudades > 5)) and (self.beneficiosVigentes().size() >= 3)

  override method valorFinal() = if (self.esPremium()) super() * 1.05 else super()
}

class PackInternacional inherits Pack {
  const property paisDestino
  const property cantidadDeEscalas = 0
  var property esLugarDeInteres = false

  override method esPremium() = (esLugarDeInteres and (duracion > 20)) and (cantidadDeEscalas == 0)

  override method valorFinal() = super() * 1.2
}

class Coordinador {
  var property estaMotivado = false
  var property cantidadDeViajes = 0
  var property aniosDeExperiencia = 0
  var rol = guia

  method initialize() {
    self.validarRol(rol)
  }

  method rol() = rol

  method cambiarRol(nuevoRol) {
    self.validarRol(nuevoRol)
    rol = nuevoRol
  }

  method validarRol(unRol) {
    if (![guia, asistenteLogistico, acompaniante].contains(unRol)) self.error(
        "El rol no es válido"
      )
  }

  method altamenteCalificado() = (cantidadDeViajes > 20) and rol.cumpleCondicion(
    self
  )
}

class Beneficio {
  const property tipo
  const property costo
  var property estaVigente
}

object guia {
  method cumpleCondicion(coordinador) = coordinador.estaMotivado()
}

object asistenteLogistico {
  method cumpleCondicion(coordinador) = coordinador.aniosDeExperiencia() >= 3
}

object acompaniante {
  method cumpleCondicion(coordinador) = true
}
