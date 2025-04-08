pipeline {
    agent any
    
    tools {
        terraform 'TerraformTool'
    }

    environment {
        // GitHub hitelesítő adat, amit a Jenkins-ben kell beállítanod
        GIT_CREDENTIALS = credentials('GIT_ACCESS_KEY')
        // AWS hitelesítő adatok környezeti változók
        AWS_CREDENTIALS = credentials('AWS_SECRET_ACCESS_KEY')  // Jenkins hitelesítési kulcs az AWS számára
        AWS_REGION = 'eu-central-1'  // Az AWS régió, ahol a Terraform fog futni
    }

    stages {
        stage('Checkout') {
            steps {
                // GitHub repository-ból való kód letöltése
                git credentialsId: "${GIT_CREDENTIALS}", url: 'https://github.com/Inckrisz/JenkinsDockerTerraform.NET.git', branch: 'main'
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    // A terraform mappába lépés, és terraform init végrehajtása
                    dir('terraform') {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    // A terraform mappába lépés, és terraform plan végrehajtása
                    dir('terraform') {
                        sh 'terraform plan'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    // A terraform mappába lépés, és terraform apply végrehajtása
                    dir('terraform') {
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Clean Up') {
            steps {
                script {
                    // Input kérdés, ami lehetővé teszi a törlés manuális megerősítését
                    def userInput = input(
                        message: 'Biztosan törölni akarod az erőforrásokat?',
                        parameters: [
                            choice(
                                name: 'Törlés',
                                choices: ['Igen', 'Nem'],
                                description: 'Ha biztos vagy a törlésben, válaszd az Igen-t.'
                            )
                        ]
                    )

                    // Ha az input válasz "Igen", akkor törlés végrehajtása
                    if (userInput == 'Igen') {
                        dir('terraform') {
                            sh 'terraform destroy -auto-approve'
                        }
                    } else {
                        echo 'Törlés megszakítva.'
                    }
                }
    }

    post {
        always {
            // Bármilyen esetben futó tisztítás (pl. logok törlése)
            echo 'Pipeline végrehajtása befejeződött'
        }

        success {
            // Ha sikeres volt a pipeline
            echo 'Terraform alkalmazás sikeres volt!'
        }

        failure {
            // Ha a pipeline hibát jelez
            echo 'A Terraform alkalmazás hibát okozott!'
        }
    }
}
}
}