//! Biblioteca Rust compilada a WebAssembly para ClothoTag.
//!
//! Expone la función `calc_co2` al entorno JavaScript mediante wasm-bindgen.

use wasm_bindgen::prelude::*;

/// Calcula la huella de CO₂ en kilogramos a partir del peso (kg).
///
/// # Fórmula
/// ```text
/// CO₂ = peso_kg × 2.5
/// ```
#[wasm_bindgen]                 // <-- ¡necesario para exportar a JS/WASM!
pub fn calc_co2(weight_kg: f64) -> f64 {
    weight_kg * 2.5
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_calculates_co2() {
        assert_eq!(calc_co2(2.0), 5.0);
        assert_eq!(calc_co2(2.5), 6.25);
    }
}
