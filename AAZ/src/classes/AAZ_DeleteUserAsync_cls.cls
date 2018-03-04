/****************************************************************************************
	Desarrollado por:  Avanxo México
	Autor:             Luis Enrique Garcia Sanabria 
	Proyecto:          Mesa de Control Afore
	Descripción:       Clase de para borrar un usuario en TIBCO 
	Cambios (Versiones)     
	-------------------------------------     
	  No.      Fecha                  Autor                      Descripción     
	------  -------------  ------------------------------   ----------------------    
	 0.1     06-09-2017    Luis Enrique Garcia Sanabria     Creacion
	 0.2     06-09-2017    Luis Enrique Garcia Sanabria     Construcción
	 1.0     06-09-2017    Luis Enrique Garcia Sanabria     Finalización y documentación
****************************************************************************************/
global class AAZ_DeleteUserAsync_cls {
	
	public static void deleteUserTibco(Map<Id,User> userInformation, Map<Id,User> userInformationOld){
		Set<String> setEmployeeNumber = new Set<String>();
		Set<User> setIdUser = new Set<User>();
		for(Id idUser: userInformationOld.keySet()) {	
			if(userInformation.get(idUser).IsActive != userInformationOld.get(idUser).IsActive){
				if(!userInformation.get(idUser).IsActive) {
					if(userInformation.get(idUser).EmployeeNumber != null ){
						if(!String.isBlank(userInformationOld.get(idUser).EmployeeNumber)) {
							System.debug(loggingLevel.Error, '*** Aqui6: ');
							setEmployeeNumber.add(userInformationOld.get(idUser).EmployeeNumber);		
						}
					}
				}

				else {
					if (userInformation.get(idUser).EmployeeNumber != userInformationOld.get(idUser).EmployeeNumber) {
                        string a1=userInformation.get(idUser).EmployeeNumber;
                        String a2=userInformationOld.get(idUser).EmployeeNumber;

						if(userInformation.get(idUser).EmployeeNumber != null || !String.isBlank(userInformation.get(idUser).EmployeeNumber)) {
							if(userInformationOld.get(idUser).EmployeeNumber == null || String.isBlank(userInformationOld.get(idUser).EmployeeNumber)) {
								System.debug(loggingLevel.Error, '*** Aqui1: ');
								setIdUser.add(userInformation.get(idUser));
							}
							else if (userInformationOld.get(idUser).EmployeeNumber != null || !String.isBlank(userInformationOld.get(idUser).EmployeeNumber)) {
								System.debug(loggingLevel.Error, '*** Aqui2: ');
								setIdUser.add(userInformation.get(idUser));	
								setEmployeeNumber.add(userInformationOld.get(idUser).EmployeeNumber);
							}	
						} else if (userInformation.get(idUser).EmployeeNumber == null || String.isBlank(userInformation.get(idUser).EmployeeNumber)) {
							if(userInformationOld.get(idUser).EmployeeNumber != null || !String.isBlank(userInformationOld.get(idUser).EmployeeNumber)) {
								setEmployeeNumber.add(userInformationOld.get(idUser).EmployeeNumber);
							}
						}

					} else {
						if(userInformationOld.get(idUser).EmployeeNumber != null ){
							if(!String.isBlank(userInformationOld.get(idUser).EmployeeNumber)) {
								System.debug(loggingLevel.Error, '*** Aqui3: ');
								setIdUser.add(userInformation.get(idUser));	
							}
						}
					}
					

				}
			}

			else if (userInformation.get(idUser).EmployeeNumber != userInformationOld.get(idUser).EmployeeNumber) {
				if(userInformation.get(idUser).EmployeeNumber != null || !String.isBlank(userInformation.get(idUser).EmployeeNumber)) {
					if(userInformationOld.get(idUser).EmployeeNumber == null || String.isBlank(userInformationOld.get(idUser).EmployeeNumber)) {
						System.debug(loggingLevel.Error, '*** Aqui4: ');
						setIdUser.add(userInformation.get(idUser));
					}
					else if (userInformationOld.get(idUser).EmployeeNumber != null || !String.isBlank(userInformationOld.get(idUser).EmployeeNumber)) {
						System.debug(loggingLevel.Error, '*** Aqui5: ');
						setIdUser.add(userInformation.get(idUser));	
						setEmployeeNumber.add(userInformationOld.get(idUser).EmployeeNumber);
					}	
				} else if (userInformation.get(idUser).EmployeeNumber == null || String.isBlank(userInformation.get(idUser).EmployeeNumber)) {
					if(userInformationOld.get(idUser).EmployeeNumber != null || !String.isBlank(userInformationOld.get(idUser).EmployeeNumber)) {
						setEmployeeNumber.add(userInformationOld.get(idUser).EmployeeNumber);
					}
				}
			}
		}
		processCase(setEmployeeNumber);

		for(User idSetUser: setIdUser) {
			System.debug(loggingLevel.Error, '*** Aqui: ');
			AAZ_CreateUserAsync_cls createUserAsync = new AAZ_CreateUserAsync_cls();
        	createUserAsync.usr = idSetUser;
        	if(!Test.isRunningTest()){
                String jobId = System.enqueueJob(createUserAsync);
            }
		}		
	}

	@future (callout=true)
	public static void processCase (set<String> deleteUser){
		for(String idUserSet: deleteUser) {
            if(!Test.isRunningTest()){
			AAZ_SecurityServices_cls.deleteTibcoUser(idUserSet);
            }
            }
            
	}
}