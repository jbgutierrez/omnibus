class Requirement < ActiveRecord::Base
  versioned :if => lambda {|r| r.status.changed? and !new_record? }

  state_machine :initial => :original, :attribute => :status do
    event :anular do
      transition [ any - :anulado ] => :anulado
    end
    event :continuar do
      transition :original   => :detallado
      transition :detallado  => :en_curso
      transition :en_curso   => :en_pruebas
      transition :en_pruebas => :finalizado
      transition :finalizado => :implantado
      transition :modificar  => :detallado
    end
    event :modificar do
      transition :implantado => :modificado
    end
    event :alterar do
      transition [ :detallado, :en_curso, :en_pruebas, :finalizado ] => :alterado
    end
    event :retroceder_a_detallado do
      transition :alterado => :detallado
    end
    
    event :retroceder_a_en_curso do
      transition :alterado => :en_curso
    end
    event :retroceder_a_en_pruebas do
      transition :alterado => :en_pruebas
    end
    event :retroceder_a_finalizado do
      transition :alterado => :finalizado
    end
  end
  
  def state_transitions_names
    state_transitions.map(&:to)
  end
  
  def self.status_values
    [ :original, :detallado, :en_curso, :en_pruebas, :finalizado, :implantado, :modificar, :alterado ]
  end
  
  def self.release_versions
    Requirement.all(:select => 'release_version', :group => 'release_version').reject{ |r| r.release_version.blank? }.map{ |r| r.release_version }
  end
end
